# GKE Deploy

## Sample kubernetes template

Notice the {{commit-sha}} placeholder - we're replacing this with the actual
commit SHA:

```yaml
---

# This is the web application deployment:
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: my-app-web
  namespace: default
  labels:
    app: my-app
spec:
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: puma
        image: gcr.io/your-google-cloud-project/some-image:{{commit-sha}}
        ports:
        - containerPort: 3000
          name: my-app-web
        envFrom:
        - configMapRef:
            name: my-app-config
        env:
        - name: DATABASE_PASSWORD
          valueFrom:
            secretKeyRef:
              name: my-app-secrets
              key: database_password
        - name: SECRET_KEY_BASE
          valueFrom:
            secretKeyRef:
              name: my-app-secrets
              key: secret_key_base

---

# This is the web application service configuration:
apiVersion: v1
kind: Service
metadata:
  name: my-app-web-load-balancer
  namespace: default
  labels:
    app: my-app

spec:
  type: LoadBalancer
  selector:
    app: my-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
```


## Sample DroneCI file:

```yaml
---

kind: pipeline
name: Deploy

steps:

- name: Deploy to GKE
  image: icalialabs/gke-deploy:latest
  settings:
    zone: us-central1-a
    project: your-google-cloud-project
    cluster: your-gke-cluster
    deploy_template: path-to/your-deploy-template.yml
    # used in `kubectl rollout status deployment/${deployment_name}`:
    deployment_name: the-name-you-gave-to-the-deployment-object
    # See https://cloud.google.com/container-registry/docs/advanced-authentication#json_key_file
    json_key:
      from_secret: THE_KEY_YOU_ADDED_TO_DRONE_SECRETS
```
