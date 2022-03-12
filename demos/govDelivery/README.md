# govDelivery Custom Connector
This sample shows how to easily consume govDelivery APIs to send SMS text messages and email notifications to citizens.  We have also provided a sample custom connector that streamlines the process to get started and building Power Automate Flows with govDelivery.

![Sample Flow](files/sample-flow.jpg)

To get started, you will need a govDelivery account and an API key to connect to their APIs.  Details on govDelivery's APIs can be found below,

[govDelivery API Docs](https://developer.govdelivery.com/api/tms/overview/Setup/)

## Installing the Custom Connector
To install the sample custom connector, download the following swagger OpenAPI connection file,

[govDelivery Swagger Definition File](files/govDelivery.swagger.json)

Next, go to Power Automate > Data > Custom Connectors.

![Custom Connectors](files/custom-connectors-ui.jpg)

Next, create a new custom connector from an OpenAPI file,

![Custom Connectors](files/custom-connectors-create.jpg)

Import the ```govDelivery.swagger.json``` you downloaded previously.  Name the connector ```govDelivery```

![Custom Connectors](files/custom-connectors-create-2.jpg)

Click on "Create connector".  Now go to Test and then create a new connection,

![Custom Connectors](files/custom-connectors-create-connection.jpg)

You will need to then input the API key assigned from govDelivery,

![Custom Connectors](files/custom-connectors-create-api-input.jpg)

Refresh the connections and you should now see the new connection you just created,

![Custom Connectors](files/custom-connectors-saved.jpg)

Now you can test the connector by sending SMS text messages or emails!

![Custom Connectors](files/custom-connectors-test.jpg)

You can also now use this custom connector in any Power Automate Flows in the environment you installed the custom connector in,

![Custom Connector action](files/custom-connectors-in-flow.jpg)

Below is a sample Flow using the custom connector,

![Sample Flow](files/sample-flow.jpg)
