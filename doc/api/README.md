<!--- This section is copied from: https://raw.github.com/gitlabhq/gitlabhq/master/doc/api/README.md -->

# DAP API

All API requests require authentication (if not stated different). You need to pass a `private_token` parameter by url or header.

If no valid `private_token` is provided then an error message will be returned with status code 401:

```json
{
  "message": "401 Unauthorized"
}
```

API requests should be prefixed with `api` and the API version. Current API version is `v1`

Example of a valid API request:

```
GET https://example.com/api/v1/levees?private_token=FSGa2df2gSdfg
```

Example for a valid API request using curl and authentication via header:

```
curl --header "PRIVATE-TOKEN: QVy1PB7sTxfy4pqfZM1U" https://example.com/api/v1/levees
```

## Status codes

The API is designed to return different status codes according to context and action. In this way if a request results in an error the caller is able to get insight into what went wrong, e.g. status code `422 Unprocessable Entity` is returned if a required attribute is missing from the request. The following list gives an overview of how the API functions generally behave.

API request types:

* `GET` requests access one or more resources and return the result as JSON. Objects array with root equals into resource name (e.g. `levees` for listing all levees and `levee` for getting a single levee) is returned
* `POST` requests return `201 Created` if the resource is successfully created and returns the newly created resource as a JSON
* `POST` and `PUT` requests expect the same format as is returned by a single-resource query
* `GET`, `PUT` and `DELETE` return `200 Ok` if the resource is accessed, modified or deleted successfully, the (modified) result is returned as a JSON

The following list shows the possible return codes for API requests.

Return values:

* `200 Ok` - The `GET`, `PUT` or `DELETE` request was successful, the resource(s) itself is returned as JSON
* `201 Created` - The `POST` request was successful and the resource is returned as JSON
* `400 Bad Request` - The request cannot be fulfilled due to bad syntax.
* `401 Unauthorized` - The user is not authenticated, a valid user token is necessary, see above
* `403 Forbidden` - The request is not allowed, e.g. the user is not allowed to delete a levee
* `404 Not Found` - A resource could not be accessed, e.g. an ID for a resource could not be found
* `405 Method Not Allowed` - The request is not supported
* `409 Conflict` - A conflicting resource already exists, e.g. creating a appliance type with a name that already exists
* `422 Unprocessable Entity` - A required attribute of the API request is missing or in wrong format, e.g. the name of a timeline is not given
* `500 Server Error` - While handling the request something went wrong on the server side
