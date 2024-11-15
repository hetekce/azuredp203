import asyncio
from azure.eventhub.aio import EventHubConsumerClient
from azure.eventhub.extensions.checkpointstoreblobaio import BlobCheckpointStore
from azure.storage.blob.aio import ContainerClient
from azure.eventhub import TransportType
import os
from dotenv import load_dotenv


load_dotenv()

# Replace with your Event Hub connection string and Event Hub name
EVENTHUB_CONNECTION_STR = os.environ.get('EVENT_HUB_CONNECTION_STRING')
EVENTHUB_NAME = os.environ.get('EVENT_HUB_NAME')
CONSUMER_GROUP = '$Default'  # Replace with your consumer group if needed
STORAGE_CONNECTION_STR = os.environ['STORAGE_ACCOUNT_CONNECTION_STRING']
CONTAINER_NAME = os.environ['CONTAINER_NAME']
SAS_POLICY = os.environ["EVENT_HUB_SAS_POLICY"]
SAS_KEY = os.environ["EVENT_HUB_SAS_KEY"]
FULLY_QUALIFIED_NAMESPACE = os.environ["EVENT_HUB_HOSTNAME"]


async def on_event(partition_context, event):
    
    # Print the event data
    print(f"Received event from partition {partition_context.partition_id}: {event.body_as_str()}")

    # Update the checkpoint (this is optional but useful for tracking progress)
    await partition_context.update_checkpoint(event)

async def receive_events():
    # Create a Blob Checkpoint Store
    checkpoint_store = BlobCheckpointStore.from_connection_string(
        conn_str=STORAGE_CONNECTION_STR, 
        container_name=CONTAINER_NAME
    )
    
    # # Create a consumer client to receive messages from the event hub
    # consumer = EventHubConsumerClient.from_connection_string(
    #     conn_str=EVENTHUB_CONNECTION_STR,
    #     consumer_group=CONSUMER_GROUP,
    #     eventhub_name=EVENTHUB_NAME
    # )
    
    # # Illustration of commonly used parameters.
    # consumer = EventHubConsumerClient.from_connection_string(
    #     conn_str=EVENTHUB_CONNECTION_STR,
    #     consumer_group=CONSUMER_GROUP,
    #     eventhub_name=EVENTHUB_NAME,  # EventHub name should be specified if it doesn't show up in connection string.
    #     logging_enable=False,  # To enable network tracing log, set logging_enable to True.
    #     retry_total=3,  # Retry up to 3 times to re-do failed operations.
    #     transport_type=TransportType.Amqp,  # Use Amqp as the underlying transport protocol.
    # )

    # # Create consumer client from constructor.
    # consumer = EventHubConsumerClient(
    #     fully_qualified_namespace=FULLY_QUALIFIED_NAMESPACE,
    #     eventhub_name=EVENTHUB_NAME,
    #     consumer_group=CONSUMER_GROUP,
    #     credential=EventHubSharedKeyCredential(policy=SAS_POLICY, key=SAS_KEY),
    #     logging_enable=False,  # To enable network tracing log, set logging_enable to True.
    #     retry_total=3,  # Retry up to 3 times to re-do failed operations.
    #     transport_type=TransportType.Amqp,  # Use Amqp as the underlying transport protocol.
    # )
    
    # Create a consumer client with checkpointing
    consumer = EventHubConsumerClient.from_connection_string(
        conn_str=EVENTHUB_CONNECTION_STR,
        consumer_group=CONSUMER_GROUP,
        eventhub_name=EVENTHUB_NAME,
        checkpoint_store=checkpoint_store  # Use checkpoint store for persistence
    )

    # Receive events
    async with consumer:
        await consumer.receive(
            on_event=on_event,
            starting_position="-1"  # Start receiving from the beginning of the partition
        )

if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(receive_events())
