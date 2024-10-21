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
package org.eclipse.kapua.commons.util;

import org.eclipse.kapua.commons.setting.KapuaSettingErrorCodes;
import org.eclipse.kapua.commons.setting.KapuaSettingException;
import org.eclipse.kapua.qa.markers.junit.JUnitTests;
import org.hamcrest.CoreMatchers;
import org.junit.Assert;
import org.junit.Test;
import org.junit.experimental.categories.Category;

import java.io.File;
import java.lang.reflect.Constructor;
import java.net.MalformedURLException;
import java.net.URL;

/**
 * {@link KapuaFileUtils} {@link JUnitTests}
 *
 * @since 1.3.0
 */
@Category(JUnitTests.class)
public class KapuaFileUtilsTest {

    @Test
    public void kapuaFileUtilsTest() throws Exception {
        Constructor<KapuaFileUtils> fileUtilsConstructor = KapuaFileUtils.class.getDeclaredConstructor();
        fileUtilsConstructor.setAccessible(true);
        fileUtilsConstructor.newInstance();
    }

    @Test
    public void getAsUrlTest() throws KapuaSettingException, MalformedURLException {
        String[] stringUrls = new String[]{
                "https://www.google.com/",
                "http://www.google.com:1080/docs/resource1.html",
                "https://www.google.com:1080/docs/resource2.html",
                "file:///c:/EXAMPLE/clock.example"
        };

        URL[] expectedUrls = new URL[]{
                new URL("https://www.google.com/"),
                new URL("http://www.google.com:1080/docs/resource1.html"),
                new URL("https://www.google.com:1080/docs/resource2.html"),
                new URL("file:///c:/EXAMPLE/clock.example")
        };

        for (int i = 0; i < stringUrls.length; i++) {
            Assert.assertEquals(stringUrls[i], expectedUrls[i], KapuaFileUtils.getAsURL(stringUrls[i]));
        }
    }

    @Test
    public void getAsUrlInvalidTest() {
        String[] invalidUrls = new String[]{
                "www.google.com:1080/docs/resource1.html",
                "/c:/WINDOWS/clock.example",
                "http://www.example.com:10800000000000/docs/resource1.html",
                "htp://www.example.com:1080/docs/resource1.html"
        };

        for (String invalidUrl : invalidUrls) {
            try {
                KapuaFileUtils.getAsURL(invalidUrl);

                Assert.fail("Exception should be thrown with this test. URL: " + invalidUrl);
            } catch (KapuaSettingException kse) {
                Assert.assertThat(kse.getCode(),
                        CoreMatchers.anyOf(
                                CoreMatchers.is(KapuaSettingErrorCodes.INVALID_RESOURCE_NAME),
                                CoreMatchers.is(KapuaSettingErrorCodes.RESOURCE_NOT_FOUND)
                        ));

                if (kse.getCause() != null) {
                    Assert.assertEquals("invalidUrl", MalformedURLException.class, kse.getCause().getClass());
                }
            }
        }
    }

    @Test
    public void getAsFileTest() {
        String[] stringUrls = new String[]{
                "https://opensource.apple.com/",
                "https://www.lipsum.com/"};
        for (String stringURL : stringUrls) {
            try {
                File file = KapuaFileUtils.getAsFile(stringURL);

                Assert.assertNotNull(file);
                Assert.assertTrue(file.exists());
            } catch (KapuaSettingException kse) {
                Assert.fail("Failed to get the file or the URL is no longer valid. Please check ULRs used in the test. Failed URL:" + stringURL);
            } catch (Exception ex) {
                Assert.fail("Failed but not for the URL being wrong, likely. Good luck to find the cause! Failed URL:" + stringURL);
            }
        }
    }

    @Test
    public void getAsFileInvalidUrlTest() {
        String[] invalidURLs = new String[]{
                "file://",
                "http://www.example.com:10800000000000/docs/resource1.html"
        };

        for (String invalidURL : invalidURLs) {
            try {
                KapuaFileUtils.getAsFile(invalidURL);

                Assert.fail("Exception should be thrown with this test. URL: " + invalidURL);
            } catch (KapuaSettingException kse) {
                Assert.assertEquals(invalidURL, KapuaSettingErrorCodes.INVALID_RESOURCE_NAME, kse.getCode());
                Assert.assertNotNull(kse.getCause());
            }
        }
    }

    @Test
    public void getAsFileInvalidResourceTest() {
        String[] invalidURLs = new String[]{
                "file:/hostname/path/the%20file.txt",
                "/c:/WINDOWS/clock.example",
                "https://www.w3.org/TR/PNG/iso_88591.txt",
                "p://txt2html.sourceforge.net/invalidName.txt",
        };

        for (String invalidURL : invalidURLs) {
            try {
                KapuaFileUtils.getAsFile(invalidURL);
                Assert.fail("Exception should be thrown with this test. URL: " + invalidURL);
            } catch (KapuaSettingException kse) {
                Assert.assertEquals(invalidURL, KapuaSettingErrorCodes.RESOURCE_NOT_FOUND, kse.getCode());
            }
        }
    }

    @Test(expected = NullPointerException.class)
    public void getAsURLNullPathTest() throws KapuaSettingException {
        KapuaFileUtils.getAsURL(null);
    }

    @Test(expected = NullPointerException.class)
    public void getAsFileNullPathTest() throws KapuaSettingException {
        KapuaFileUtils.getAsFile(null);
    }
}
