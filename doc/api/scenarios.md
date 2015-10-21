## List Scenarios

Obtains a list of all Scenarios present in the registry. Each Scenario may have multiple Timelines and belong to multiple Experiments. You need to authorize yourself with a valid user account (secret token).

```
GET /scenarios
```
No parameters are required, although it is possible to filter by selected attributes by extending the GET request with query parameters. Note that it is also possible to filter scenarios by experiment_id - in this case only those scenarios which are linked to the selected experiment will be returned. The response is a JSON file.

```json
{
  "scenarios": [
    {
      "id": numerically unique id (e.g. 1),
      "name": short identifier of the scenario,
      "description": arbitrary string presenting the details of the scenario,
      "experiment_ids": array of identifiers of experiments attached to the scenario
    }, {
      ...
    }
  ]
}
```

## Details of a Scenario

```
GET /scenarios/:id
```

Parameters:

+ `id` (required) - The ID of the Scenario you are interested in, as returned by the GET /scenarios call. Multiple (comma-separated) values can be entered.

```json
{
  "scenario": {
      "id": numerically unique id (e.g. 1),
      "name": short identifier of the scenario,
      "description": arbitrary string presenting the details of the scenario,
      "experiment_ids": array of identifiers of experiments attached to the scenario
  }
}
```
