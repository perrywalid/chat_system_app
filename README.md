# Chat System Application

This is a chat system application built with Ruby on Rails. It supports creating applications, chats, and messages, and includes features like asynchronous job processing and data consistency checks.

## Features

- **Applications Management**: Create and view applications identified by unique tokens.
- **Chats Management**: Within each application, manage chats identified by unique numbers.
- **Messages Management**: Within each chat, manage messages identified by unique numbers.
- **Search Functionality**: Search through messages using ElasticSearch for partial content matching.
- **Count Tracking**: Maintain `chats_count` and `messages_count` with updates no more than a minute behind.
- **Concurrency Handling**: Safely handle concurrent requests with race condition prevention.
- **Performance Optimizations**: Optimized database queries with appropriate indexing.
- **Containerization**: Easily run the entire stack with `docker-compose up`.

## Getting Started

To get started with the application, follow these steps:

1. Clone the repository:
    ```sh
    git clone https://github.com/perrywalid/chat_system_app.git
    cd chat-system-app
    ```

2. Build and start the containers:
    ```sh
    docker-compose up --build
    ```

3. Access the web container:
    ```sh
    docker-compose exec web bash
    ```

3. Run the rake tasks to index Elasticsearch:
    ```sh
    rake searchkick:reindex:all
    ```

## Documentation

### Database Schema

You can find the database schema in the following file:
- [db/schema.rb](https://github.com/perrywalid/chat_system_app/blob/main/db/schema.rb)

### API Controllers

The API controllers are implemented in the following files:
- [app/controllers/applications_controller.rb](https://github.com/perrywalid/chat_system_app/blob/main/app/controllers/applications_controller.rb)
- [app/controllers/chats_controller.rb](https://github.com/perrywalid/chat_system_app/blob/main/app/controllers/chats_controller.rb)
- [app/controllers/messages_controller.rb](https://github.com/perrywalid/chat_system_app/blob/main/app/controllers/messages_controller.rb)

### Workers

The workers are implemented in the following files:
- [app/jobs/application_job.rb](https://github.com/perrywalid/chat_system_app/blob/main/app/jobs/application_job.rb)
- [app/jobs/persist_object_job.rb](https://github.com/perrywalid/chat_system_app/blob/main/app/jobs/persist_object_job.rb)
- [app/jobs/redis_consistency_job.rb](https://github.com/perrywalid/chat_system_app/blob/main/app/jobs/redis_consistency_job.rb)
- [app/jobs/data_consistency_job.rb](https://github.com/perrywalid/chat_system_app/blob/main/app/jobs/data_consistency_job.rb)

### Tasks

The tasks are implemented in the following file:
- [lib/tasks/scheduler.rake](https://github.com/perrywalid/chat_system_app/blob/main/lib/tasks/scheduler.rake)

## Running Tests

To run the test suite, use the following command:
```sh
bundle exec rspec
```