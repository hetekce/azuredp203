# 5. Azure Cosmos DB

Azure Cosmos DB is a globally distributed, multi-model database service by Microsoft, designed to provide high availability, low latency, and scalability across multiple regions. It’s used to store and manage large volumes of data with fast read and write operations, making it ideal for real-time applications. Key features include:

- **Global Distribution**: Data can be replicated across multiple Azure regions, providing seamless, low-latency access to users worldwide.
- **Multi-Model Support**: Supports various data models, including document (JSON), key-value, column-family, and graph, allowing flexibility for different types of applications.
- **Consistency Levels**: Offers five consistency models (Strong, Bounded Staleness, Session, Consistent Prefix, and Eventual) to balance between performance and data consistency.
- **Scalability and Low Latency**: Automatically scales to handle large throughput with single-digit millisecond response times, supporting real-time use cases.

Azure Cosmos DB is widely used for applications like e-commerce, IoT, gaming, and social media, where fast response times and global reach are essential.

In Azure Cosmos DB, **transactional store** and **column store** refer to different storage models used within the database to optimize for specific workloads:

## 5.1. Transactional Store

The **transactional store** in Cosmos DB is designed to handle OLTP (Online Transaction Processing) workloads. This store is optimized for real-time, high-performance operations and supports transactional consistency. Key characteristics of the transactional store include:

- **Real-Time Updates**: Supports fast, real-time reads and writes. It’s suited for applications that require immediate data availability for each operation.
- **Document-Oriented Storage**: Cosmos DB primarily uses a document-based model (JSON format), allowing it to store and retrieve structured, semi-structured, or unstructured data efficiently.
- **ACID Transactions**: Ensures transactional consistency within single partition keys, which is beneficial for operations that need to maintain strict consistency guarantees.
- **Low Latency**: Designed for low-latency reads and writes, making it ideal for applications that require fast response times, such as e-commerce systems, IoT applications, and user-facing APIs.

In summary, the **transactional store** is optimized for real-time, operational data workloads that demand high-throughput and low-latency access, and it guarantees consistency at the partition level.

## 5.2. Analytical (Column) Store

The **column store** in Cosmos DB, often referred to as the **analytical store**, is optimized for OLAP (Online Analytical Processing) workloads. It is designed to support analytical queries efficiently by storing data in a columnar format. Key characteristics of the column store include:

- **Columnar Storage Format**: Data is stored in a column-based format rather than a row-based format, which is optimized for analytical queries that aggregate data across multiple rows but access fewer columns.
- **Optimized for Large-Scale Analytics**: Supports large-scale analytical queries, making it ideal for business intelligence, reporting, and complex data analysis tasks.
- **Automatic Synchronization**: Cosmos DB can automatically synchronize data between the transactional store and the analytical store, so any updates in the transactional store are reflected in the column store. This eliminates the need for ETL (Extract, Transform, Load) processes.
- **Integration with Azure Synapse Analytics**: The analytical store is directly integrated with Azure Synapse, allowing users to run analytical queries on Cosmos DB data without impacting the performance of the transactional store.

In summary, the **column store** in Cosmos DB is designed to support analytics and reporting workloads, providing a way to efficiently perform complex queries on large datasets without impacting the performance of transactional operations. 

### Key Differences Between Transactional Store and Column Store

| Feature                   | Transactional Store                | Column Store                      |
|---------------------------|------------------------------------|-----------------------------------|
| **Optimized For**         | OLTP (Real-time operations)       | OLAP (Analytics and reporting)    |
| **Data Format**           | Document-based (JSON)             | Columnar                          |
| **Consistency**           | ACID transactions at partition level | Eventual consistency across replicas |
| **Query Performance**     | Fast for single-record lookups and inserts | Fast for aggregation and analytical queries |
| **Integration**           | Direct access through Cosmos DB API | Azure Synapse Analytics integration |

The combination of these two stores within Cosmos DB allows it to support both real-time applications and analytical workloads within the same database environment, providing a flexible solution for mixed workload applications.

In Azure Cosmos DB, **synchronization** between the **transactional store** and the **analytical store** is automatic and near real-time. When data is written to the transactional store, it’s immediately replicated to the analytical (column) store without requiring any manual ETL process(there can be a latency of 2 to 5 minutes). This enables up-to-date analytics on operational data, allowing users to run analytical queries on the latest data without impacting transactional performance. 

This seamless synchronization ensures that both stores remain consistent, supporting fast operational and analytical processing within a single database.

## 5.3. Time-to-Live (TTL)

In Azure Cosmos DB, **Time-to-Live (TTL)** is a feature that automatically deletes items after a specified duration, helping to manage storage costs and data lifecycle. Here’s how it works:

- **Global TTL**: You can set a default TTL at the container level, so all items in the container expire after a specified time.
- **Item-Level TTL**: Alternatively, you can set individual TTL values for specific items within a container, overriding the container-level setting if needed.
- **TTL Value**: TTL is specified in seconds. After the TTL expires, the items are automatically deleted by Cosmos DB’s background process.
- **“No Expiry” Option**: If an item has a TTL value of `-1`, it will not expire, even if a global TTL is set at the container level.

TTL helps optimize storage and ensure data relevance by removing outdated information without manual intervention. This is especially useful for scenarios like session data, logs, or any temporary information that doesn’t need to be stored permanently.

## 5.4. Embedded Entities

In Azure Cosmos DB, **embedded entities** refer to the practice of embedding related data directly within a parent document, rather than storing it in separate documents or collections. This approach is especially common in document-oriented databases, as it allows for storing complex, hierarchical data in a single JSON document, reducing the need for joins and improving query efficiency.

### Key Benefits of Embedded Entities

1. **Improved Read Performance**: Since all related data is stored in a single document, Cosmos DB can fetch the entire entity in one query, which is faster than retrieving data from multiple documents.
2. **Atomicity**: When data is embedded in one document, updates to that data are atomic, meaning they occur as a single transaction. This is beneficial for maintaining consistency.
3. **Reduced Network Overhead**: Embedding data avoids multiple calls to the database, reducing network latency and overhead.
4. **Hierarchical Data Modeling**: Embedded entities are a natural fit for hierarchical data structures, like orders and items, users and addresses, or posts and comments.

### When to Use Embedded Entities

Embedded entities are ideal when:
- The embedded data is closely related to the parent document and does not need to be accessed independently.
- Data changes together as a single unit (e.g., user profile and settings).
- The structure will not lead to excessively large documents, as Cosmos DB has a document size limit (currently 2 MB per document).

### Example of Embedded Entity in Cosmos DB

Suppose we have a user document with embedded addresses:

```json
{
  "id": "user1",
  "name": "Alice",
  "email": "alice@example.com",
  "addresses": [
    {
      "type": "home",
      "street": "123 Main St",
      "city": "Springfield",
      "zip": "12345"
    },
    {
      "type": "work",
      "street": "456 Office Rd",
      "city": "Metropolis",
      "zip": "67890"
    }
  ]
}
```

In this structure:
- The `addresses` array is embedded within the user document, making it easy to retrieve all addresses along with user details in a single read.
- Changes to the user document, such as adding or updating addresses, will be atomic.

### When Not to Use Embedded Entities

Avoid embedding if:
- The embedded data is large or changes independently (e.g., products in an inventory, or posts in a social media feed).
- You need to frequently query or update the embedded data on its own.

Embedded entities are a powerful modeling technique in Cosmos DB, enabling efficient data retrieval and simpler application logic when used for tightly coupled data.