## List Parameters

Obtains a list of all Parameters present in the registry. You need to authorize yourself with a valid user account (secret token).

```
GET /parameters
```
No parameters are required.

```json
{
  "parameters": [
    {
          "id": numerically unique id (e.g. 1),
          "custom_id": external identifier of the parameter, specific to the levee installation setup,
          "parameter_name": name of the parameter,
          "device_id": identifier of a device measuring the parameter,
          "monitored": should this parameter be processed by the data streaming monitoring worker? (true/false),
          "monitoring_status": if monitored is set to true, indicates the current streaming status for this parameter (unknown, up or down),
          "measurement_type_name": data type name,
          "measurement_type_unit": data unit,
          "timeline_ids": list of measurement timeline ids.
    }, {
      ...
    }
  ]
}
```

## Details of a Parameter

```
GET /parameters/:id
```

Parameters:

+ `id` (required) - The ID of the Parameter you are interested in, as returned by the GET /parameters call. Multiple (comma-separated) values can be entered.

```json
{
  "parameter": {
        "id": numerically unique id (e.g. 1),
        "custom_id": external identifier of the parameter, specific to the levee installation setup,
        "parameter_name": name of the parameter,
        "device_id": identifier of a device measuring the parameter,
        "monitored": should this parameter be processed by the data streaming monitoring worker? (true/false),
        "monitoring_status": if monitored is set to true, indicates the current streaming status for this parameter (unknown, up or down),
        "measurement_type_name": data type name,
        "measurement_type_unit": data unit,
        "timeline_ids": list of measurement timeline ids.
  }
}
```
