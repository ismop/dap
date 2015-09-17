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
        "parent_id": identifier of parent device aggregation,
        "children_ids": identifiers of children - other aggregations,
        "type": string representing type of the device aggregation,
        "shape": geometric coordinates of the device aggregation, expressed as a GeoJSON data structure,
        "profile_id": identifier of the profile the device aggregations belongs to,
        "section_id": identifier of the section the device aggregations belongs to,
        "levee_id": identifier of the levee the device aggregations belongs to,
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
      "custom_id": external identifier of the device aggregation, specific to the levee installation setup,
      "parent_id": identifier of parent device aggregation,
      "children_ids": identifiers of children - other aggregations,
      "type": string representing type of the device aggregation,
      "shape": geometric coordinates of the device aggregation, expressed as a GeoJSON data structure,
      "profile_id": identifier of the profile the device aggregations belongs to,
      "section_id": identifier of the section the device aggregations belongs to,
      "levee_id": identifier of the levee the device aggregations belongs to,
      "device_ids": identifiers of aggregated devices
  }
}
```
