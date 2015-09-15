## List fiber optic nodes

Obtains a list of all fiber optic nodes present in the registry. You need to authorize yourself with a valid user account (secret token).
Fiber optic nodes are temperature measurement points placed along sections of a fiber optic cable. They run parallel to the embankment,
along its crest.

```
GET /fiber_optic_nodes
```
No parameters are required

```json
{
  "fiber_optic_nodes": [
    {
      "id": numerically unique id (e.g. 1),
      "cable_distance_marker": linear separation between the node and the beginning of the FO cable. Expressed in meters.
      "levee_distance_marker": linear separation between the node and the starting point of the levee. Expressed in meters.
      "deployment_date": specifies when the node was installed,
      "last_state_change": specifies when the last state change occurred. For current state refer to the /activity_state/ attribute.
      "device_id": specifies which device the node belongs to
    }, {
      ...
    }
  ]
}
```

## Details of a fiber optic node

```
GET /fiber_optic_nodes/:id
```

Parameters:

+ `id` (required) - The ID of the node you are interested in, as returned by the GET /fiber_optic_nodes call

```json
{
  "fiber_optic_node": {
      "id": numerically unique id (e.g. 1),
      "cable_distance_marker": linear separation between the node and the beginning of the FO cable. Expressed in meters.
      "levee_distance_marker": linear separation between the node and the starting point of the levee. Expressed in meters.
      "deployment_date": specifies when the node was installed,
      "last_state_change": specifies when the last state change occurred. For current state refer to the /activity_state/ attribute.
      "device_id": specifies which device the node belongs to
  }
}
```
