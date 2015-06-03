## List Neosentio Sensors

Obtains a list of all Neosentio Sensors present in the registry. You need to authorize yourself with a valid user account (secret token).

```
GET /neosentio_sensors
```
No parameters are required, although it is possible to filter by selected attributes (equality tests only) by extending the GET request with query parameters. The response is a JSON file with the /placement/ object expressed as a GeoJSON data structure of type Point with elevation info. See http://geojson.org/geojson-spec.html for details. The 3D coordinates are given in the popular WGS 84 system, with elevation expressed as meters above (or below) sea level.

```json
{
  "neosentio_sensors": [
    {
        THIS DOCUMENTATION IS HAS TO BE UPDATED.
    }, {
      ...
    }
  ]
}
```

## Details of a Neosentio Sensor

```
GET /neosentio_sensors/:id
```

Parameters:

+ `id` (required) - The ID of the Neosentio Sensor you are interested in, as returned by the GET /neosentio_sensors call

```json
{
  "neosentio_sensor": {
        THIS DOCUMENTATION IS HAS TO BE UPDATED.
  }
}
```
