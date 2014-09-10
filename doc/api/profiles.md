## List profiles

Get a list of all profiles present in the registry. You need to authorize yourself with an administrator account (a token).
Profiles represent cross-sections of the embankment (levee) and aggregate sensors. Each sensor may belong to a single profile.

```
GET /profiles
```

No parameters are required.

```json
{
  "profiles": [
    {
      "id": a numerical unique id (e.g. 1),
      "name": some human-readable name of the profile,
      "sensor_ids": identifiers of sensors which belong to the target profile.
    }, {
      ...
    }
  ]
}
```


## Details of a profile

Get the JSON document about a given profile. You need to authorize yourself with an administrator account (a token).

```
GET /profiles/:id
```

Parameters:

+ `id` (required) - The ID of the profile you are interested in, as returned by the GET /profiles call

```json
{
  "profile": {
      "id": a numerical unique id (e.g. 1),
      "name": some human-readable name of the profile,
      "sensor_ids": identifiers of sensors which belong to the target profile.
  }
}
```
