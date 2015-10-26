## List Threat Assessments

Get a list of all threat assessments which have been defined. You need to authorize yourself with an administrator account (a token).
Each threat assessment is launched for a set of profiles (see the appropriate API description) and produces results, i.e. similarity
scores for each timeline and each sensor belonging to any of the target profiles. Each threat assessment is also bound to a specific
ThreatAssessmentRun.

```
GET /threat_assessments
```

No parameters are required.

```json
{
  "threat_assessments": [
    {
      "id": a numerical unique id (e.g. 1),
      "threat_assessment_run_id": identifier of the threat assessment run for which this threat assessment was launched,
      "profile_ids": identifiers of profiles which are covered by this threat assessment,
      "results": all results registered for this threat assessment
    }, {
      ...
    }
  ]
}
```

## Details of a Threat Assessment

Get the JSON document about a given threat assessment. You need to authorize yourself with an administrator account (a token).

```
GET /threat_assessments/:id
```

Parameters:

+ `id` (required) - The ID of the threat assessment you are interested in, as returned by the GET /threat_assessments call

```json
{
  "threat_assessment": {
    "id": a numerical unique id (e.g. 1),
    "threat_assessment_run_id": identifier of the threat assessment run for which this threat assessment was launched,
    "profile_ids": identifiers of profiles which are covered by this threat assessment,
    "results": all results registered for this threat assessment
  }
}
```
## Create a new Threat Assessment

Allows you to create a new threat assessment. You may pass a list of profile IDs which will be covered by this threat assessment.

You need to authorize yourself with an administrator account (a token).

```
POST /threat_assessments/
```

Parameters:

+ `threat_assessment_run_id` - identifier of the threat assessment run for this threat assessment,
+ `profile_ids` (optional): an array of profile IDs which are covered by this threat assessment.

The operation return the JSON representation of the newly created threat assessment

## Update the details of a given Threat Assessment

Allows you to change selected details of a threat assessment. You need to authorize yourself with an administrator account (a token).

```
PUT /threat_assessments/:id
```

Parameters:

+ `id` (required) - The ID of the threat assessment you are interested in, as returned by the GET /threat_assessments call
+ `threat_assessment_run_id` - the ID of the threat assessment run for which this threat assessment was launched
+ `profile_ids` (optional): identifiers of profiles which are covered by this threat assessment.

The operation return the JSON representation of this threat assessment (much like the GET /threat_assessments/id operation), with the updated field values, or a suitable error code, when a problem occurs.