## Show monitoring status

Obtains a list of all Parameters for which the data monitoring process is active and no measurements are currently being received. You need to authorize yourself with a valid user account (secret token).

```
GET /monitoring
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
          "monitored": is this parameter processed by the data streaming monitoring process? (this will always be listed as true in the monitoring view),
          "monitoring_status": indicates the current streaming status for this parameter (this will always be listed as down in the monitoring view)
    }, {
      ...
    }
  ]
}
```