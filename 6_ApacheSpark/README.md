# 6. Understanding Apache Spark

Azure Databricks is a cloud-based analytics platform on Azure, optimized for big data and machine learning. It runs on Apache Spark and allows data teams to collaborate in a unified workspace, supporting multiple languages like Python, SQL, and Scala. It integrates seamlessly with Azure services, providing scalability, security, and support for ETL, machine learning, and real-time analytics.

## 6.1. Spark Cluster Components

1. **Job**: A job is triggered when a Spark action (e.g., `count()`, `collect()`) is called. It represents a complete computation workflow.  
   *Example*: If you call `df.count()`, Spark creates a job to count the records in `df`.

2. **Stage**: A job is divided into stages based on shuffle boundaries. Each stage is a set of tasks that can be executed in parallel without needing to shuffle data.  
   *Example*: If the job involves filtering and then grouping data, it could be split into two stages (one for filtering, another for grouping and aggregating).

3. **Task**: Each stage is further divided into tasks, which are units of work executed on partitions of data. Each task processes a subset of data independently. A task is sent from the driver node to the worker nodes. 
   *Example*: If the dataset has 10 partitions, then 10 tasks are created to process each partition.

4. **Slot**: Work sent from the driver nodes to the worker nodes is assigned to slots, instructing them to pull data from a specified data source. A slot is a unit of computing resource (like CPU and memory) on a Spark executor, used to run tasks. Each executor has a limited number of slots based on its configuration.  
   *Example*: If an executor has 4 slots, it can run 4 tasks in parallel.

5. **Worker**: The Spark clusters, or datasets, are also known as workers.

6. **Driver**: An Apache Spark cluster, the driver is the notebook interface. It contains the main loop for the program and creates distributed datasets on the cluster.

### Small Example

Consider a job that reads data, filters it, and then aggregates by a key:

- **Job**: Entire workflow to read, filter, and aggregate.
- **Stage 1**: Filter stage, parallelized over the data partitions.
- **Stage 2**: Aggregate stage, requires shuffling and is also parallelized.
- **Tasks**: Each stage has multiple tasks, one for each data partition.
- **Slots**: If there are 4 slots per executor, up to 4 tasks can run simultaneously on each executor.

To put it all together:

- In Spark, **work** submitted to the cluster is split into **Jobs**. **Jobs** are divided into **stages**, and **stages** are divided into **tasks**.
- The **driver** coordinates the entire process by distributing the work to **executors** (also called workers).
- Each **executor** runs tasks in parallel using available **slots** (CPU and memory resources).

In short: *The driver sends the workload to executors, and tasks are executed in parallel within slots on each executor.* 

The architecture of a spark job looks like:

![Architecture](pictures/1.png)

Since databricks provides robust high performing cluster management solution, we don't need to concern with the cluster management. From a developer perspective, our primiraly focus should be on the following issues:

1. Number of partitions your data divided into
2. Number of available slots for parallel execution
3. Number of jobs triggered
4. Number of stages the jobs divided into

## 6.2. Performance Enhancements in Apache Spark

Shuffle operations and the Tungsten engine in Apache Spark both play crucial roles in enhancing performance, particularly when working with large-scale data. Let’s break down how each contributes to performance improvements with an example:

### Shuffle Operations
In Spark, a shuffle is an operation that redistributes data across partitions, often between nodes. This process is essential for transformations that require data to be aggregated or joined, such as `groupBy`, `reduceByKey`, and `join`.

However, shuffling is computationally expensive. It involves reading, serializing, and transferring data across the network, and then deserializing it at the destination. Spark optimizes shuffle performance through techniques like sorting, partitioning, and reducing the amount of data transferred by using combiner functions. These optimizations help lower I/O and network overhead, which can significantly improve speed in distributed processing.

**Example:**
Suppose you have a dataset of users and their purchases in Spark, and you want to calculate the total purchase amount by each user. When you call `reduceByKey` on a dataset of `(user_id, purchase_amount)`, Spark will use a combiner function during the shuffle. This step reduces data sent across the network by combining the sums locally within each partition before shuffling, thereby minimizing the data transferred and making the aggregation faster.

### Tungsten Engine
The Tungsten project in Spark is a major engine optimization that allows Spark to improve CPU and memory utilization through:
1. **Memory Management**: Tungsten uses off-heap memory to manage data more efficiently, reducing garbage collection (GC) overhead.
2. **Code Generation**: It performs bytecode generation at runtime, eliminating the need to interpret Spark operations, which makes execution much faster.
3. **Cache-Aware Computation**: Tungsten optimizes CPU cache utilization, making data processing faster by keeping frequently accessed data in CPU caches.

Here is the key optimizations a Data Engineer should focus on in Spark to boost performance:

### 1. **Data Partitioning**
   - **Why It’s Important:** Shuffle operations are costly, and how data is partitioned across nodes can greatly affect performance. While Spark handles partitioning automatically, poor partitioning can lead to excessive shuffle or imbalanced data distribution.
   - **What You Can Do:** Use `repartition` and `coalesce` commands to divide data into optimal partitions for your operations. For example, repartitioning data before `groupBy` or `join` operations can reduce shuffle costs and improve efficiency.

### 2. **Minimizing Shuffle Operations**
   - **Why It’s Important:** Shuffle operations are among the most resource-intensive in Spark, and too much shuffling can significantly slow down processing.
   - **What You Can Do:** Avoid unnecessary shuffles by using transformations like `reduceByKey` instead of `groupByKey`. `reduceByKey` allows partial aggregations within each partition, which reduces the amount of data transferred over the network.

### 3. **Optimizing Wide Transformations**
   - **Why It’s Important:** Wide transformations such as `groupBy`, `join`, and `distinct` require data redistribution, causing shuffle operations that can be expensive in terms of time and resources.
   - **What You Can Do:** Filter or partition the data effectively before applying wide transformations. For instance, using a `broadcast join` for smaller datasets allows Spark to replicate the smaller dataset across all partitions, reducing shuffle requirements.

### 4. **Choosing Efficient Data Types**
   - **Why It’s Important:** Although the Tungsten engine optimizes memory and processing, data type selection still impacts memory efficiency and speed.
   - **What You Can Do:** Use the smallest data types possible. For example, choosing `ShortType` over `IntegerType` can save memory and improve speed, especially for large datasets. Efficient data type selection reduces Spark’s memory load and speeds up computation.

### 5. **Effective Use of Cache and Persist**
   - **Why It’s Important:** Recalculating the same dataset repeatedly is inefficient, especially if the dataset is used across multiple transformations.
   - **What You Can Do:** Use `cache()` or `persist()` for frequently accessed data to store it in memory. However, manage memory carefully—caching too much data can cause memory overflow and trigger frequent garbage collection.

### 6. **Using Kryo Serialization for Better Performance**
   - **Why It’s Important:** Serialization transfers data between nodes in the cluster, and Java’s default serialization can be slow.
   - **What You Can Do:** Use Kryo serialization (`org.apache.spark.serializer.KryoSerializer`) in Spark configurations. Kryo is faster and more efficient than Java serialization, especially for complex data structures.

### 7. **Selecting Only Necessary Columns**
   - **Why It’s Important:** Working with unneeded columns increases memory usage and processing time, as Spark processes each column in a DataFrame or RDD.
   - **What You Can Do:** Use `select` to retrieve only the required columns before transformations. This reduces memory load and allows Tungsten to process data more efficiently.

### 8. **Understanding DAG Optimization**
   - **Why It’s Important:** Spark organizes transformations as Directed Acyclic Graphs (DAGs), and optimizing DAG operations can reduce processing time significantly.
   - **What You Can Do:** By understanding how Spark structures the DAG, you can avoid unnecessary transformations and shuffle operations. For example, minimize redundant `repartition` calls, and use efficient bulk operations to process data in fewer steps.

By keeping these considerations in mind, you can complement Spark's internal optimizations to maximize processing efficiency and manage resources effectively, especially with large datasets.

### Catalyst Optimizer

The Catalyst Optimizer is Apache Spark's powerful and extensible query optimization framework, used primarily within Spark SQL and DataFrame APIs to automatically optimize queries for efficient execution. Catalyst makes Spark SQL queries fast and efficient by applying a series of transformations to the query plan—essentially rewriting and optimizing the query in multiple stages before it’s executed. 

Here’s a breakdown of how Catalyst Optimizer works and why it’s important:

1. **Logical Plan Optimization**:
   - Catalyst starts with the **logical plan** of a query, which is a high-level representation of the computation Spark needs to perform.
   - Catalyst applies a series of **rule-based transformations** to optimize the logical plan. For example, it might push filters down to narrow the dataset early, or reorder joins to reduce intermediate data size.

2. **Physical Plan Optimization**:
   - After optimizing the logical plan, Catalyst generates a **physical plan**, which is a lower-level, execution-ready representation of the query. 
   - Catalyst may create multiple physical plans and select the most efficient one based on a **cost model** (i.e., estimated resources each plan would use).

3. **Code Generation (Whole-Stage Codegen)**:
   - Catalyst generates Java bytecode that efficiently executes each query by leveraging **whole-stage code generation**. This means that multiple stages of the query are combined into a single code path to minimize runtime overhead.

4. **Extensibility**:
   - Catalyst is built to be extensible, allowing developers to add new optimization rules, data sources, and custom transformations. This extensibility makes it adaptable to a wide range of applications.

Here are some of the specific optimizations Catalyst performs:

- **Predicate Pushdown**: Moves filters closer to the data source, minimizing the amount of data loaded and processed.
- **Constant Folding**: Simplifies expressions by evaluating constant expressions at compile time rather than runtime.
- **Projection Pruning**: Eliminates unnecessary columns from being loaded and processed.
- **Join Reordering**: Reorders joins to reduce intermediate data by putting the smaller datasets first, which can significantly reduce shuffle costs.
- **Subquery Elimination**: Removes duplicate subqueries or replaces them with more efficient representations when possible.

### How Catalyst Optimizer Works: Example

Consider the query:
```sql
SELECT name, age FROM users WHERE age > 21 ORDER BY age
```

1. **Logical Plan Creation**: Spark first generates a logical plan based on this query. This plan includes operations like a filter for `age > 21`, a selection of columns `name` and `age`, and an ordering step.

2. **Logical Optimization**: Catalyst applies optimizations like predicate pushdown, reordering operations, and column pruning. For instance, if the `ORDER BY` operation is more efficient after filtering, Catalyst will reorder these operations.

3. **Physical Plan Selection**: Catalyst generates multiple possible execution strategies (physical plans) and chooses the most efficient one based on the cost model. For example, it might choose a sort-based or hash-based approach depending on data characteristics.

4. **Code Generation**: Once the physical plan is finalized, Catalyst generates optimized bytecode that efficiently executes the query, leveraging whole-stage codegen to minimize processing time.
