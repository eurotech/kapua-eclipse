/*******************************************************************************
 * Copyright (c) 2020, 2022 Eurotech and/or its affiliates and others
 *
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 *     Eurotech - initial API and implementation
 *******************************************************************************/
package org.eclipse.kapua.model.xml.adapters;

import org.eclipse.kapua.model.xml.XmlPropertyAdapted;
import org.eclipse.kapua.qa.markers.junit.JUnitTests;
import org.junit.Assert;
import org.junit.Test;
import org.junit.experimental.categories.Category;
import org.mockito.Mockito;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Category(JUnitTests.class)
public class XmlPropertiesAdapterTest {
    public enum TestTypes {
        First,
        Second,
        Third,
        Fourth
    }

    public static class TestPropertyAdapted implements XmlPropertyAdapted<TestTypes> {

        public TestPropertyAdapted() {
        }

        public TestPropertyAdapted(String name,
                                   TestTypes type,
                                   String... values) {
            super();
            this.name = name;
            this.type = type;
            this.encrypted = false;
            this.array = values != null && values.length > 1;
            this.values = values;
        }

        /**
         * The name of the property.
         */
        @XmlAttribute(name = "name")
        private String name;

        /**
         * Whether the property value is an array.
         */
        @XmlAttribute(name = "array")
        private boolean array;

        /**
         * Whether the property value is encrypted.
         */
        @XmlAttribute(name = "encrypted")
        private boolean encrypted;

        /**
         * The property type.
         */
        @XmlAttribute(name = "type")
        private TestTypes type;

        /**
         * The property value(s).
         */
        @XmlElement(name = "value")
        private String[] values;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public boolean getArray() {
            return array;
        }

        public void setArray(boolean array) {
            this.array = array;
        }

        public TestTypes getType() {
            return type;
        }

        public void setType(TestTypes type) {
            this.type = type;
        }

        public boolean isEncrypted() {
            return encrypted;
        }

        public void setEncrypted(boolean encrypted) {
            this.encrypted = encrypted;
        }

        public String[] getValues() {
            return values;
        }

        public void setValues(String[] values) {
            this.values = values;
        }
    }

    public static class TestPropertiesAdapter extends XmlPropertiesAdapter<TestTypes, TestPropertyAdapted> {
        public TestPropertiesAdapter(Map<TestTypes, XmlPropertyAdapter> adapters) {
            super(TestPropertyAdapted.class, () -> new TestPropertyAdapted(), adapters);
        }
    }

    @Test
    public void testMarshalling() {
        //Given adapters
        final StringPropertyAdapter stringAdapter = Mockito.spy(new StringPropertyAdapter());
        final BooleanPropertyAdapter booleanAdapter = Mockito.spy(new BooleanPropertyAdapter());
        final LongPropertyAdapter longAdapter = Mockito.spy(new LongPropertyAdapter());
        final HashMap<TestTypes, XmlPropertyAdapter> adapters = new HashMap<TestTypes, XmlPropertyAdapter>() {
            {
                put(TestTypes.First, stringAdapter);
                put(TestTypes.Second, booleanAdapter);
                put(TestTypes.Fourth, longAdapter);
            }
        };
        //and an instance
        final XmlPropertiesAdapter<TestTypes, TestPropertyAdapted> instance = new TestPropertiesAdapter(adapters);
        //When I marshal
        final TestPropertyAdapted[] adapted = instance.marshal(new HashMap<String, Object>() {
            {
                put("aString", "theString");
                put("aBoolean", new Boolean[]{true, false});
            }
        });
        //Then I obtain two property marshalled properties
        Assert.assertNotNull(adapted);
        Assert.assertEquals(2, adapted.length);
        final Map<TestTypes, List<TestPropertyAdapted>> byType = Arrays.stream(adapted)
                .collect(Collectors.groupingBy((XmlPropertyAdapted<TestTypes> v) -> v.getType()));
        Assert.assertEquals(2, byType.keySet().size());
        Assert.assertNotNull(byType.get(TestTypes.First));
        Assert.assertEquals(1, byType.get(TestTypes.First).size());
        final TestPropertyAdapted firstItem = byType.get(TestTypes.First).get(0);
        Assert.assertEquals(TestTypes.First, firstItem.getType());
        Assert.assertEquals("aString", firstItem.getName());
        Assert.assertEquals(false, firstItem.getArray());
        Assert.assertEquals(1, firstItem.getValues().length);
        Assert.assertEquals("theString", firstItem.getValues()[0]);

        Assert.assertEquals("aString", firstItem.getName());
        Assert.assertNotNull(byType.get(TestTypes.Second));
        Assert.assertEquals(1, byType.get(TestTypes.Second).size());
        final TestPropertyAdapted secondItem = byType.get(TestTypes.Second).get(0);
        Assert.assertEquals(TestTypes.Second, secondItem.getType());
        Assert.assertEquals("aBoolean", secondItem.getName());
        Assert.assertEquals(true, secondItem.getArray());
        Assert.assertEquals(2, secondItem.getValues().length);
        Assert.assertEquals("true", secondItem.getValues()[0]);
        Assert.assertEquals("false", secondItem.getValues()[1]);

        //and I have the expected call sequence
        Mockito.verify(stringAdapter, Mockito.atLeastOnce()).canMarshall(Mockito.any());
        Mockito.verify(booleanAdapter, Mockito.atLeastOnce()).canMarshall(Mockito.any());
        Mockito.verify(stringAdapter, Mockito.times(1)).marshallValue(Mockito.eq("theString"));
        Mockito.verify(booleanAdapter, Mockito.times(1)).marshallValue(Mockito.eq(true));
        Mockito.verify(booleanAdapter, Mockito.times(1)).marshallValue(Mockito.eq(false));
        Mockito.verify(longAdapter, Mockito.never()).marshallValue(Mockito.any());
    }

    @Test
    public void testUnmarshallingMissingProperties() {
        //Given adapters
        final StringPropertyAdapter stringAdapter = Mockito.spy(new StringPropertyAdapter());
        final HashMap<TestTypes, XmlPropertyAdapter> adapters = new HashMap<TestTypes, XmlPropertyAdapter>() {
            {
                put(TestTypes.First, stringAdapter);
            }
        };
        //and an instance
        final XmlPropertiesAdapter instance = new TestPropertiesAdapter(adapters);
        //When I unmarshal
        final Map<String, Object> got = instance.unmarshal(null);
        Map<String, Object> expectedResult = new HashMap<>();
        Assert.assertEquals(got, expectedResult);
    }

    @Test
    public void testUnmarshalling() {
        //Given adapters
        final StringPropertyAdapter stringAdapter = Mockito.spy(new StringPropertyAdapter());
        final BooleanPropertyAdapter booleanAdapter = Mockito.spy(new BooleanPropertyAdapter());
        final LongPropertyAdapter longAdapter = Mockito.spy(new LongPropertyAdapter());
        final HashMap<TestTypes, XmlPropertyAdapter> adapters = new HashMap<TestTypes, XmlPropertyAdapter>() {
            {
                put(TestTypes.First, stringAdapter);
                put(TestTypes.Second, booleanAdapter);
                put(TestTypes.Fourth, longAdapter);
            }
        };
        //and an instance
        final XmlPropertiesAdapter instance = new TestPropertiesAdapter(adapters);
        //When I unmarshal
        final Map<String, Object> got = instance.unmarshal(new TestPropertyAdapted[]{
                new TestPropertyAdapted("aString", TestTypes.First, "TheString"),
                new TestPropertyAdapted("aBoolean", TestTypes.Second, "false", "true"),
                new TestPropertyAdapted("anotherValue", TestTypes.Third, "42")
        });
        //Then I get two unmarshalled properties (the last one gets ignored as we don't have a PropertyAdapter for TestTypes.Third)
        Assert.assertNotNull(got);
        Assert.assertEquals(2, got.keySet().size());
        Assert.assertNotNull(got.get("aString"));
        Assert.assertNotNull(got.get("aBoolean"));
        Assert.assertEquals("TheString", got.get("aString"));
        Assert.assertArrayEquals(new Boolean[]{false, true}, (Boolean[]) got.get("aBoolean"));
        //and I have the expected call sequence
        Mockito.verify(stringAdapter, Mockito.times(1)).unmarshallValue(Mockito.eq("TheString"));
        Mockito.verify(booleanAdapter, Mockito.times(1)).unmarshallValue(Mockito.eq("false"));
        Mockito.verify(booleanAdapter, Mockito.times(1)).unmarshallValue(Mockito.eq("true"));
        Mockito.verify(longAdapter, Mockito.never()).unmarshallValue(Mockito.any());
    }

    @Test
    public void testUnmarshallingMissingType() {
        //Given adapters
        final StringPropertyAdapter stringAdapter = Mockito.spy(new StringPropertyAdapter());
        final BooleanPropertyAdapter booleanAdapter = Mockito.spy(new BooleanPropertyAdapter());
        final LongPropertyAdapter longAdapter = Mockito.spy(new LongPropertyAdapter());
        final HashMap<TestTypes, XmlPropertyAdapter> adapters = new HashMap<TestTypes, XmlPropertyAdapter>() {
            {
                put(TestTypes.First, stringAdapter);
                put(TestTypes.Second, booleanAdapter);
                put(TestTypes.Fourth, longAdapter);
            }
        };
        //and an instance
        final XmlPropertiesAdapter instance = new TestPropertiesAdapter(adapters);
        //When I unmarshal
        Assert.assertThrows(IllegalArgumentException.class, () -> instance.unmarshal(new TestPropertyAdapted[]{
                new TestPropertyAdapted("aString", TestTypes.First, "TheString"),
                new TestPropertyAdapted("aBoolean", TestTypes.Second, "false", "true"),
                new TestPropertyAdapted("anotherValue", null, "42")
        }));
    }
}