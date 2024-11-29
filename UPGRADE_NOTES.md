# Upgrade Notes v 2.0.0-SNAPSHOT

Below are described most important changes, features, additions and bugfixes that needs attention while performing the upgrade from the previous version.

This report is only partial for Eclipse Kapua release 2.0.0-SNAPSHOT, since we started to maintain it mid-release development.

## Changes

#### Deprecation of `db.pool.size.min` and `db.pool.size.max` sizing options

With [#4112](https://github.com/eclipse/kapua/pull/4112) we deprecated `commons.db.pool.size.min` and `commons.db.pool.size.max` settings, switching to a new `commons.db.pool.size.fixed` setting which will configure the database connection pool to a fixed size with a default value of `5`.

Backward compatibility is granted by `db.pool.size.strategy`. Default value is `fixed`, but it can be changed to `range` to continue use of a variable database connection pool. Be aware that at some point `range` strategy will be removed and only fixed size will be available.

## DB Changes

#### New column in MFA Option table

In PR [#4115](https://github.com/eclipse/kapua/pull/4115) a new `has_trust_me` column has been added to the `atht_mfa_option`.

New column defaults to `null` and doesn't need any migration. The code itself will populate the column accordingly on first update.
For large `atht_mfa_option` tables it might take sometime to be added.