## List experiments

Get a list of all experiments which have been defined. You need to authorize yourself with an administrator account (a token).
Each experiment is launched for a set of profiles (see the appropriate API description) and produces results, i.e. similarity
scores for each timeline and each sensor belonging to any of the target profiles.

```
GET /experiments
```

No parameters are required. The /selection/ parameter is given in a notation called GeoJSON, that uses JSON document
to denote geographical data. More information at http://geojson.org/geojson-spec.html. Currently, we use the
Polygon geometric type to describe the area which has been tagged by the experiment's creator - any profile which
contains at least one sensor falling within the target polygon will be included in the experiment.

```json
{
  "experiments": [
    {
      "id": a numerical unique id (e.g. 1),
      "name": some human-readable name of the experiment,
      "selection": the geometry of the user-selected area, given in the GeoJSON notation as a Polygon object (without an inner ring).
      "start_date": beginning of the experiment (timestamp),
      "end_date": end of the experiment (timestamp),
      "status": current experiment status. Permitted values are: "unknown", "started", "finished", "error"
      "profile_ids": identifiers of profiles which are covered by this experiment,
      "result_ids": identifiers of all results registered for this experiment
    }, {
      ...
    }
  ]
}
```

## Details of an experiment

Get the JSON document about a given experiment. You need to authorize yourself with an administrator account (a token).

```
GET /experiments/:id
```

Parameters:

+ `id` (required) - The ID of the experiment you are interested in, as returned by the GET /experiments call

```json
{
  "experiment": {
    "id": a numerical unique id (e.g. 1),
    "name": some human-readable name of the experiment,
    "selection": the geometry of the user-selected area, given in the GeoJSON notation as a Polygon object (without an inner ring).
    "start_date": beginning of the experiment (timestamp),
    "end_date": end of the experiment (timestamp),
    "status": current experiment status. Permitted values are: "unknown", "started", "finished", "error"
    "profile_ids": identifiers of profiles which are covered by this experiment,
    "result_ids": identifiers of all results registered for this experiment
  }
}
```
## Create a new experiment

Allows you to create a new experiment. You can provide a name, initial status, start date, end date and selection polygon for the experiment. You may also pass a list of profile IDs which will be
covered by this experiment.

You need to authorize yourself with an administrator account (a token).

```
POST /experiments/
```

Parameters:

+ `name` (optional) - some human-readable name of the experiment,
+ `selection` (optional) - the geometry of the user-selected area, given in the GeoJSON notation as a Polygon object (without an inner ring).
+ `start_date` (optional) - beginning of the experiment (timestamp),
+ `end_date` (optional) - end of the experiment (timestamp),
+ `status` (optional): current experiment status. Permitted values are: "unknown", "started", "finished", "error",
+ `profile_ids` (optional): an array of profile IDs which are covered by this experiment.

The operation return the JSON representation of the newly created experiment

## Update the details of a given experiment

Allows you to change selected details of an experiment - specifically, its name, status, start_date, end_date, selection and list of profiles. No other attributes of the experiment can be changed through this operation. You need to authorize yourself with an administrator account (a token).

```
PUT /experiments/:id
```

Parameters:

+ `id` (required) - The ID of the experiment you are interested in, as returned by the GET /experiments call
+ `name` (optional) - some human-readable name of the experiment,
+ `selection` (optional) - the geometry of the user-selected area, given in the GeoJSON notation as a Polygon object (without an inner ring).
+ `start_date` (optional) - beginning of the experiment (timestamp),
+ `end_date` (optional) - end of the experiment (timestamp),
+ `status` (optional): current experiment status. Permitted values are: "unknown", "started", "finished", "error"
+ `profile_ids` (optional): identifiers of profiles which are covered by this experiment.

The operation return the JSON representation of this experiment (much like the GET /experiments/id operation), with the updated field values, or a suitable error code, when a problem occurs.