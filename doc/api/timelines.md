## List Timelines

Obtains a list of all Timelines present in the registry. Each Timeline belongs to exactly one Sensor and may have multiple Measurements. You need to authorize yourself with a valid user account (secret token).

```
GET /timelines
```
No parameters are required, although it is possible to filter by selected attributes (equality tests only) by extending the GET request with query parameters. The response is a JSON file.

```json
{
  "timelines": [
    {
      "id": numerically unique id (e.g. 1),
      "name": user-defined name of this timeline,
      "measurement_type": type of this timeline. Valid options: "actual" (actual sensor readings), "simulated" (simulated sensor readings), "forecast" (predicted sensor readings)
      "sensor_id": ID of the sensor represented by this timeline.
    }, {
      ...
    }
  ]
}
```

## Details of a Timeline

```
GET /timelines/:id
```

Parameters:

+ `id` (required) - The ID of the Timeline you are interested in, as returned by the GET /timelines or GET /sensors call

```json
{
  "timeline": {
      "id": numerically unique id (e.g. 1),
      "name": user-defined name of this timeline,
      "measurement_type": type of this timeline. Valid options: "actual" (actual sensor readings), "simulated" (simulated sensor readings), "forecast" (predicted sensor readings)
      "sensor_id": ID of the sensor represented by this timeline.
  }
}
```