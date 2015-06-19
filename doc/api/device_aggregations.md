## List Device Aggregations

Obtains a list of all Device Aggregations present in the registry. You need to authorize yourself with a valid user account (secret token).

```
GET /device_aggregations
```
No parameters are required.

```json
{
  "device_aggregations": [
    {
        "id": numerically unique id (e.g. 1),
        "custom_id": external identifier of the device, specific to the levee installation setup,
        "placement": geometric coordinates of the device_aggregation, expressed as a GeoJSON data structure,
        "profile_id": identifier of a profile the aggreagation belong to,
        "device_ids": identifiers of aggregated devices.
    },  {
      ...
    }
  ]
}
```

## Details of a Device Aggregation

```
GET /device_aggregation/:id
```

Parameters:

+ `id` (required) - The ID of the Device Aggregation you are interested in, as returned by the GET /device_aggregation call

```json
{
  "device_aggregation": {
      "id": numerically unique id (e.g. 1),
      "custom_id": external identifier of the sensor, specific to the levee installation setup,
      "placement": geometric coordinates of the sensor, expressed as a GeoJSON data structure,
      "profile_id": identifier of a profile the aggreagation belong to,
      "device_ids": identifiers of aggregated devices.
  }
}
```
