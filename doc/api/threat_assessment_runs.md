## List Threat Assessment Runs

Get a list of all threat assessment runs which have been defined. You need to authorize yourself with an administrator account (a token).
Each threat assessment run is launched for a set of threat assessments (see the appropriate API description).

```
GET /threat_assessment_runs
```

No parameters are required, however three optional parameters are accepted. "sort_by" sorts the result set by one of two date parameters
(allowed values are: "start_date" and "end_date"), while "sort_order" specifies whether this should be an ascending or descending sort
(allowed values are: "asc" and "desc" respectively; default is "asc"). The "limit" flag, accompanied by a numerical value instructs DAP
to return only a portion of the result set (the first n records, where "n" is the value of the "limit" flag).

```json
{
  "threat_assessment_runs": [
    {
      "id": a numerical unique id (e.g. 1),
      "name": some human-readable name of the threat assessment run,
      "start_date": beginning of the threat assessment run (timestamp),
      "end_date": end of the threat assessment run (timestamp),
      "status": current threat assessment run status. Permitted values are: "unknown", "started", "finished", "error",
      "threat_assessment_ids": array of identifiers of ThreatAssessment objects linked to this run
    }, {
      ...
    }
  ]
}
```

## Details of a Threat Assessment Run

Get the JSON document about a given threat assessment run. You need to authorize yourself with an administrator account (a token).

```
GET /threat_assessment_runs/:id
```

Parameters:

+ `id` (required) - The ID of the threat assessment run you are interested in, as returned by the GET /threat_assessment_runs call

```json
{
  "threat_assessment_run": {
    "id": a numerical unique id (e.g. 1),
    "name": some human-readable name of the threat assessment run,
    "start_date": beginning of the threat assessment run (timestamp),
    "end_date": end of the threat assessment run (timestamp),
    "status": current threat assessment run status. Permitted values are: "unknown", "started", "finished", "error",
    "threat_assessment_ids": array of identifiers of ThreatAssessment objects linked to this run
  }
}
```
## Create a new Threat Assessment Run

Allows you to create a new threat assessment run. You can provide a name, initial status, start date and end date for the threat assessment run.

You need to authorize yourself with an administrator account (a token).

```
POST /threat_assessment_runs/
```

Parameters:

+ `name` (optional) - some human-readable name of the threat assessment run,
+ `start_date` (optional) - beginning of the threat assessment run (timestamp),
+ `end_date` (optional) - end of the threat assessment run (timestamp),
+ `status` (optional): current threat assessment run status. Permitted values are: "unknown", "started", "finished", "error",

The operation return the JSON representation of the newly created threat assessment run

## Update the details of a given Threat Assessment Run

Allows you to change selected details of a threat assessment run - specifically, its name, status, start_date and end_date. No other attributes of the Threat Assessment Run can be changed through this operation. You need to authorize yourself with an administrator account (a token).

```
PUT /threat_assessment_runs/:id
```

Parameters:

+ `id` (required) - The ID of the threat assessment run you are interested in, as returned by the GET /threat_assessment_runs call
+ `name` (optional) - some human-readable name of the threat assessment run,
+ `start_date` (optional) - beginning of the threat assessment run (timestamp),
+ `end_date` (optional) - end of the threat assessment run (timestamp),
+ `status` (optional): current threat assessment run status. Permitted values are: "unknown", "started", "finished", "error"

The operation return the JSON representation of this threat assessment run (much like the GET /threat_assessment_runs/id operation), with the updated field values, or a suitable error code, when a problem occurs.