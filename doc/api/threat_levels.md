## List Threat Levels

Get a list of Threat Levels for all Profiles. You need to authorize yourself with an administrator account (a token).
By default five latest Threat Assessments for a profile are returned in Threat Level data. This can be altered by providing
an optional `limit` parameter.

```
GET /threat_levels[?limit=10]
```
Parameters:

+ `limit` (optional) defines how many latest Threat Assessments are returned.


```json
{
  "threat_levels":
    [
      {
        "profile_id": 3923,
        "threat_assessments":
          [
            {
              "date": "2016-07-11T08:02:24.449Z",
              "scenarios":
                [
                  {
                    "similarity": 0.8,
                    "threat_level": 2,
                    "scenario_id": 2057
                  },
                  {
                    "similarity": 0.4,
                    "threat_level": 1,
                    "scenario_id": 2058
                  }
                ]
            }
          ],
        "threat_level_assessment_runs": 
          [
            {
              "start_date": "2016-07-11T06:02:24.446Z",
              "status": "running",
              "explanation": "Assessment run has results produced less than two hours ago"
            }
          ]
      }
    ]
}
```
Additional information for selected Threat Level fields:

+ `similarity` is set to a value between 0 and 1 if valuable result was produced by simulation software or -1 if simulation was unable to produce similarity.
+ `threat_level`: 0 OK, 1 WARNING, 2 CRITICAL

Additional information for selected Threat Level Assessment Run fields:

+ `status` possible values: started, running, finished, warning, error.
+ `explanation` human readable explanation of the `status`.