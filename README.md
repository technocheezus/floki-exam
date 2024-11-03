
# SRE Assignment

### Summary

You are invited to a github repo containing a 3-tier application. It’s composed of a frontend, backend and a postgres database. A sample docker-compose is provided by the dev team so you can easily run the entire solution locally.

The application is instrumented with OpenTelemetry, it's ready to send traces, but will occasionally throw errors if you keep refreshing the page. You can refer to default endpoints used by Open Telemetry and how to override these endpoints via environment variables here: https://opentelemetry.io/docs/languages/sdk-configuration/otlp-exporter/. The OpenTelemetry docs also provide sample applications.

Prepare a local kubernetes cluster (can be minikube, k3s or similar) to run all of the following workloads:

- Postgres database
- The api that connects to database
- The web app that should communicate with the api
- Prometheus + AlertManager
- A distributed tracing backend (e.g. Grafana Tempo or Jaeger)

Setup an alert that will trigger as the api throws errors.

Feel free to use any sort of cloud solution as long as is compliant with [Open Telemetry](https://opentelemetry.io/).

Expose a UI so we can visualize application traces and look for errors.

You don't have to setup Ingress, if required we can use port-forward in Kubernetes Services to visualize the application and other monitoring components (e.g. Prometheus, Tracing UI, AlertManager).

### Bonus 1
Provision the alarms via yaml (e.g. PrometheusRule CRD).

### Bonus 2
Provision a sample Grafana Dashboard with basic kubernetes metrics (e.g. CPU, Memory).

### Bonus 3
Configure a receiver for the alerts (e.g. email).

### Bonus 4
Document all the work you've done and the whys of choosing that approach.

---

Feel free to ask questions and reach out if you find any issues. Wish you best of luck, have fun!!!
