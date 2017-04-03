## Get data required for anomaly analysis

Get data required for anomaly analysis ie. devices with parameters, timelines and measurement data.
Devices that are included in the response are selected on the basis of their distance from given Geo shape (line segment), height and section they are installed in.
Measurements included in the response are from within specified time period.
You need to authorize yourself with an administrator account (a token).
It is required to provide all query parameters.

```
GET /anomaly_data?lon1=19.676957440998&lat1=49.980045585294&lon2=19.676954693317&lat2=49.979870212959&dist1=3&dist2=4&h1=211.5&h2=212.5&from=2014-06-23%2015:50:40%20+0200&to=2014-06-23%2016:50:40%20+0200&section_ids=[4]
```
Required query parameters:

+ `lon1`, `lat1`, `lon2`, `lat2` specifies longitudes and latitudes of a line segment.
+ `dist1` and `dist2` specifies minimal and maximal distance from given line segment.
+ `h1` and `h2` specify minimal and maximal height of devices.
+ `from` and `to` specify time period for measurements. 
+ `section_ids` ids of section in which devices are installed.


```json
{
  "devices":
    [
      {
        "id":1895,
        "placement":"POINT (19.677005 49.980007 211.85)",
        "section_id":1655,
        "parameters":
          [
            {"id":3117,
             "timelines":
                [
                  {
                    "id":2898,
                    "measurements":
                      [
                        {
                          "id":10288,
                          "value":40.3594069071121,
                          "timestamp":"2017-04-03T12:56:18.885Z"
                         }
                      ]
                  }
                ]
            }
          ]
      }
    ]
}
```
