## List profiles

Get a list of all profiles present in the registry or search for profiles which are contained by a polygon.
You need to authorize yourself with an administrator account (a token).
Profiles represent cross-profiles of the embankment (levee) and aggregate sensors. Each sensor may belong to a single profile. If you want to search for profiles which are contained by a polygon feature, you need to pass the WKT (Well-Known Text) definition of this feature as an option in the GET request, with URL encoding applied.
The WKT definition of a polygon looks like this:

```
POLYGON ((0 0, 10 0, 10 10, 0 10, 0 0))
```

The above definition corresponds to a square-shaped feature originating at 0 deg N, 0 deg E, and with a span of 10 degrees. A properly declared polygon:

+ must have a nonzero internal area,
+ may not have a boundary which intersects itself
+ must be a closed loop (i.e. its boundary must terminate at its origin)

The polygon specification must be URL-encoded in the usual manner (see sample below). A profile is assumed to be belong to the specified polygon if it includes at least one sensor which is located inside the polygon's boundary. Empty (sensorless) profiles are not considered to belong to any polygon.

```
GET /profiles
GET /profiles?selection=POLYGON%20((0%200,%200%2010,%2010%2010,%2010%200,%200%200))
```

```json
{
  "profiles": [
    {
      "id": a numerical unique id (e.g. 1),
      "profile_shape": the geometry of the profile,
      "vendors": names of vendors responsible for managing devices which belong to the profile,
      "base_height": base height of the profile,
      "section_id": identifier of the section the profile belongs to,
      "levee_id": identifier of the levee the profile belongs to,
      "sensor_ids": identifiers of sensors which belong to the target profile,
      "device_ids": identifiers of devices which belong to the target profile,
      "device_aggregation_ids": identifiers of device aggregations which belong to the target profile.
    }, {
    {
     ...
    }
  ]
}
```

## Details of a profile

Get the JSON representation of a given profile. You need to authorize yourself with an administrator account (a token).

```
GET /profile/:id
```

Parameters:

+ `id` (required) - The ID of the profile you are interested in, as returned by the GET /profiles call

```json
{
  "profile": {
     "id": a numerical unique id (e.g. 1),
     "profile_shape": the geometry of the profile profile,
     "vendors": names of vendors responsible for managing devices which belong to the profile,
     "base_height": base height of the profile,
     "section_id": identifier of the section the profile belongs to,
     "levee_id": identifier of the levee the profile belongs to,
     "sensor_ids": identifiers of sensors which belong to the target profile,
     "device_aggregation_ids": identifiers of device aggregations which belong to the target profile.
  }
}
```
