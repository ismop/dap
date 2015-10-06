## List Experiments

Obtains a list of all Experiments present in the registry. Each Experiment belongs to exactly one Levee and may have multiple Timelines. You need to authorize yourself with a valid user account (secret token).

```
GET /experiments
```
No parameters are required, although it is possible to filter by selected attributes (equality tests only) by extending the GET request with query parameters. The response is a JSON file.

```json
{
  "experiments": [
    {
      "id": numerically unique id (e.g. 1),
      "name": short identifier of the experiment,
      "description": arbitrary string presenting the details of the experiment,
      "start_date": experiment start date,
      "end_date": experiment end date,
      "levee_id": ID of the levee the experiment is connected with,
      "timeline_ids": IDs of all timelines this experiment encompasses.
    }, {
      ...
    }
  ]
}
```

## Details of an Experiment

```
GET /experiments/:id
```

Parameters:

+ `id` (required) - The ID of the Experiment you are interested in, as returned by the GET /experiments call. Multiple (comma-separated) values can be entered.

```json
{
  "experiment": {
      "id": numerically unique id (e.g. 1),
      "name": short identifier of the experiment,
      "description": arbitrary string presenting the details of the experiment,
      "start_date": experiment start date,
      "end_date": experiment end date,
      "levee_id": ID of the levee the experiment is connected with,
      "timeline_ids": IDs of all timelines this experiment encompasses.
  }
}
```
