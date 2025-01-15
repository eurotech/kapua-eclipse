# Upgrade Notes v 2.0.0-BETA-M12

Below are described most important changes, features, additions and bugfixes that needs attention while performing the upgrade from the previous version.

This report is only partial for Eclipse Kapua release 2.0.0-BETA-M12, since we started to maintain it mid-release development.

## Changes

### Deprecation of `db.pool.size.min` and `db.pool.size.max` sizing options [[#4112](https://github.com/eclipse/kapua/pull/4112)]

Deprecated `commons.db.pool.size.min` and `commons.db.pool.size.max` settings, switching to a new `commons.db.pool.size.fixed` setting which will configure the database connection pool to a fixed size with a default value of `5`.

Backward compatibility is granted by `db.pool.size.strategy`. Default value is `range`, but it should be changed to `fixed` strategy because `range` strategy will be removed in future releases.


### Duplicate Name Exception is now returned as a 409 error [[#4133](https://github.com/eclipse/kapua/pull/4112)]

Fixed the HTTP response code when a `KapuaDuplicateNameException` occurs from `500 Internal error` to the correct `409 Conflict`.

The body of the response will contain additional information on the error.


### Introduction of un-scoped entities for Job Step Definitions [[#3996](https://github.com/eclipse/kapua/pull/3996)]

Introduced the concept of "Un-scoped entities" as opposite of "Scoped entities".

Normally entities belongs to a certain scope. For example: Users, Tags, Devices belongs to an Account.
There are some entities that are available for all Accounts because of their nature and usage. For example: JobStepDefinitions are available to all scopes.

With this feature we changed the way this "availability" was implemented and made it available at the core of the Service API.

User is not required to perform any action to the existing data and the migration of the Job Step Definitions will be performed by the Job Step Definition Aligner that will reflect any change to the Job Step Definitions coded into the Database.


### Invalid Trigger Exceptions are now returned as a 400 error [[#4147](https://github.com/eclipse/kapua/pull/4147)]

Fixed the HTTP response code when a `TriggerInvalidDatesException` or `TriggerInvalidSchedulingException` occurs from `500 Internal error` to the correct `400 Bad Request`.

The body of the response will contain additional information on the error.


### Max Number Of Entity Reached exception is now returned as a 403 error [[#4154](https://github.com/eclipse/kapua/pull/4154)]

Fixed the HTTP response code when a `KapuaMaxNumberOfItemsReachedException` occurs from `500 Internal error` to the correct `403 Forbidden`.

The body of the response will contain additional information on the error.


### Job Step Property value now supports JSON format for complex types [[#4161](https://github.com/eclipse/kapua/pull/4161)]

Allowed complex objects to be inserted with JSON format. Before only XML format was allowed.


### Datastore search APIs will now allow multiple `clientId` to be specified [[#4130](https://github.com/eclipse/kapua/pull/4130)]

Allowed the following REST API resources to accept more than one `clientId` as query parameter.

- `GET /{scopeId}/data/messages`
- `GET /{scopeId}/data/metric`
- `GET /{scopeId}/data/clients`
- `GET /{scopeId}/data/channels`


## DB Changes

### New column in MFA Option table [[#4115](https://github.com/eclipse/kapua/pull/4115)]

New `has_trust_me` column has been added to the `atht_mfa_option`.

New column defaults to `null` and doesn't need any migration. The code itself will populate the column accordingly on first update.
For large `atht_mfa_option` tables it might take sometime to be added.


### New column in Trigger Definition Property table [[#4134](https://github.com/eclipse/kapua/pull/4134)]

New `description` column has been added to `schdl_trigger_properties` and `schdl_trigger_definition_properties`.

The column default to `null` and the migration/population procedure will be performed by the Trigger Definition Aligner at application startup.

