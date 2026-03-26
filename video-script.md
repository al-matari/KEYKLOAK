# 0:00 to 1:15 - Introduction

On screen: repository root, README, then running application

Hi everyone, and welcome to my solution review for the Code Challenge.

And by the way welcome to my first youtube video ever.

In this video, I want to explain how I handled the challenge, what problems I found, how I ranked them, and what I changed on both backend and frontend to make the application more correct and more robust.

My goal was to treat it like a real engineering task.
So instead of only fixing isolated issues, I reviewed the full request flow end to end:
controller, service, repository, entity model, DTO mapping, API client, and React state management.

I split the work into 3 phases:

- understand the expected product behavior
- review the backend
- review the frontend

I reviewed both parts, noted the issues, implemented the main fixes, explained the trade-offs, and suggested possible improvements.

# Scope and Expected Flows

On screen: challenge description, README sections, and API overview

I started by reading the challenge material and the repository documentation to understand the expected scope.

The README describes the app as a team portal for team performance metrics and real-time activity monitoring.

The application is built around three main user-facing flows:

- a dashboard that shows team statistics
- a live activity feed
- a user profile page with recent activity

And behind those flows, there are three main API paths:

- `GET /api/teams/{team}/stats`
- `GET /api/activities/feed`
- `GET /api/users/{id}/activities`

# 2:15 to 6:00 - Backend Review and Main Findings

#### On screen: backend package structure and selected Kotlin files

I decided to start with the backend because it defines the contract the frontend relies on.

Before looking into logic issues, I made sure the application starts cleanly.
I checked Spring Boot startup, bean creation, and configuration, just to make sure I was not debugging setup problems.

After that, I focused on the project structure, API design, layers, data flow, domain model, and overall business logic.


## API
#### On screen: Postman collection, API requests, and backend responses

I analyzed the API first.

To make this easier, I created a Postman collection with happy paths and invalid input cases.
This helped me see requests and responses and test different scenarios isolated from the frontend.
For quick creation i used codex for this task.

I focused on  response structure, error messages, HTTP status codes and I compared the responses with the expected structure.

The main issues I found were:

- missing team returned 500 instead of 404
- fetching the feed triggered many SQL queries, which looked like an N+1 problem
- `userName` was null in the feed response
- feed ordering looked correct, but was not guaranteed by the service contract
- missing or invalid user returned 200 with an empty array
- validation and error flows were mostly missing

On screen: controller to repository flow, endpoint diagrams, and DTO mapping

## Data Flow

After that, I analyzed the data flow.

For example, in the team stats flow, the request goes from controller to service to repository to entity to DTO to response.
That part is clear and well structured.

The activity-related flows were weaker.
In the feed endpoint, accessing `activity.user.name` likely caused the N+1 problem.
And in the user activities endpoint, the user data was not properly mapped, which is why `userName` was null.

I also noticed that error flows were mostly missing.
The system focused on happy paths, but did not properly handle edge cases.

## Controller Layer

Then I reviewed the controller layer.

The good part is that controllers are relatively clean.
They mainly handle HTTP requests and responses, and do not contain business logic.

But there were still some issues.
There was no validation for inputs, for example invalid IDs or empty values.
And error handling was weak, because the API returned generic 500 errors instead of meaningful responses like 400 or 404.

On screen: H2 console, `data.sql`, and team membership values

## Database Layer

Then I looked at the database layer.
H2 is used, and the schema and seed data are recreated on startup.

Here I found an inconsistency issue:
the team member count did not match the actual number of users.
That created a duplicated source of truth.

Example:
Team 1 had 4 users, but `members = 12`.

On screen: entity classes and relationship mappings

## Model Layer

After that I analyzed the entities and the relations between them.

The main problems here were:

- JPA entities were modeled as Kotlin data classes, which is risky because important methods are generated automatically.
  
- fields did not have strong enough validation
- the ownership between `User.activities` and `Activity.user` was inconsistent, because the child relation was nullable
- `user.activities` was immutable, which is a bad fit for JPA collection handling
- `Activity.timestamp` was tied to object creation instead of persistence time

## service and repository Layer

After that I analyzed service and repository Layers.

The main problems here were:

- feed ordering was not guaranteed by the repository query
- the feed query caused an N+1 problem because related user data was loaded inefficiently
- the mapping was incomplete, which is why `userName` was null in the response
- missing users were not handled explicitly, so the API returned an empty list instead of a clear error
- validation and error handling were not strong enough in the service flow


## config Layer

After that I analyzed config Layers.

The main problems here were:


The main problems here were:

- CORS configuration was hardcoded in the application instead of being externalized
- the configuration was less flexible for different environments
- the allowed origins, methods, and headers were broader than needed
- the setup was harder to maintain because config and application logic were mixed together
- changing the configuration for another environment would require a code change instead of a simple config update

## Conclusion

So overall, the backend structure was understandable and mostly clean.

But the main problems were:

- consistency issues
- risky models and tightly coupled relations
- missing error handling and validation
- incomplete DTO mapping
- performance risk due to N+1 queries
- hardcoded and less flexible for different enveriment
- allo configs were broader than needed

# 6:00 to 9:45 - Backend Fixes

On screen: changed backend files, entity classes, repository queries, and exception handling

Before starting the fixes, I set up a clean Git strategy.
I created a develop branch and kept main stable, so main always stayed in a clean working state.

## Model

To fix the backend, I started by making the model more explicit.

My first thoughts.

Because of my background in java, i used here ChatGpt to check how kotlin handle this issue and found that In Kotlin, data class is risky for JPA. Because the relevant methods are automatically generated. And regular classes are recommended at this place.

Problem: JPA entities were modeled as Kotlin data classes, which is risky because important methods are generated automatically.
Fix: First, I replaced the JPA data class entities with regular classes and added explicit `toString()`, `equals()`, and `hashCode()` implementations.



Problem: the team member count did not match the actual number of users.
2. than i Removed stored Team.members and derived it from users.size.
   to Avoids drift between stored member count and actual membership.



Problem: risky models and tightly coupled relations
3. I Simplified Team to User association to a unidirectional mapping.
   i Removed the team reference from User. and i Kept Team.users so member counts can still be derived from the user list. That allowed us to Reduces relationship coupling and lazy-loading risk. For example by calling activity.user.name. Without that hibernate will call team query which we never use in logic. Alternative fix would be A @JoinTable
   but it was avoided because it would require an additional table and a broader schema change.


   
4. user.activties is immutable list
   JPA needs a mutable list because it has to track changes like adding or removing items.
   Hibernate replaces the list with its own special version to manage these changes.
   If the list is immutable, it cannot track updates properly and may cause errors.

   

Problem  the ownership between `User.activities` and `Activity.user` was inconsistent, because the child relation was nullable
5. Inconsistent ownership: User.activities vs nullable Activity.user
   I made user_id non-null because an activity without a user is not valid.
   This ensures every activity must belong to a user. I also added cascade and orphan removal so that activities are automatically managed together with the user. This makes the relationship consistent across Kotlin, JPA, and the database. optional = false is still missing on the @ManyToOne side. This means: JPA can still create Activity(user = null) in memory the error only happens later at the database level Ideally, I would also add optional = false to fully align JPA with the database.

`Activity.timestamp` was tied to object creation instead of persistence time
   The entity default used `LocalDateTime.now()` instead of a DB-managed or explicitly assigned persisted timestamp.
   that has user impacts that timestamps can be outdated or misleading.
6. i fixed the timestamp issue by Adding a JPA @PrePersist hook that sets timestamp only before insert if no value is present.
   Thats not the best way in production. But i decided for them to explore kotlin access on null values.
   LocalDateTime.now() still uses the application server clock. But is ok for this challenge.
   A Database default such as CURRENT_TIMESTAMP would be the best practice.
   Single source of truth and no clock drift across services.
   Another alternatives is @CreationTimestamp.
   Pro is Minimal code and automatic on insert.
   Contra is Hibernate-specific and more implicit.


### service
7. i complete the mapper with userName:activity.user.name
8. n+1 fix and ordering
   Added one ordered feed query with eager user loading
   i Added `findFeedActivities()` with `join fetch a.user` and `order by a.timestamp desc`.
   i Switched `ActivityService` to use that query anstead of findAll for the live feed.

I used JOIN FETCH to solve the N+1 problem because I needed the related entities immediately, and it was the most direct solution for that query.
There is other option to slove that.
@EntityGraph It tells JPA to load eagerly for a query, without writing join fetch manually. I used that in getUserById.
Option 3: is DTO Projection
DTO projection is usually the best choice for read-only endpoints like ours because it avoids loading unnecessary entity data, but I used JOIN FETCH because I still wanted managed entities. But i didn't chose it because in required changing mapping the timestamp format. i kept it easy.







## Exceptions and Validation

Problem: validation and error flows were mostly missing
Fix: After that, I added a global exception handler to centralize exception handling.
I also added endpoint validation for controller path variables and JPA validation for entity fields.

Problem: missing team returned 500 instead of 404
Fix: I added not-found handling for missing teams and users.

Problem: missing users were not handled explicitly, so the API returned an empty list instead of a clear error
Fix: I added explicit user existence checks before loading activities.

## Config

Problem: CORS configuration was hardcoded in the application instead of being externalized
Fix: Last, I externalized the CORS configuration into YAML to avoid hardcoding and improve flexibility across environments.

Problem: the allowed origins, methods, and headers were broader than needed
Fix: I also restricted it to only the needed methods and headers.

# 9:45 to 12:15 - Frontend Review

On screen: frontend folder structure, main React components, and app navigation

Once the backend was clearer and more robust, I moved to the frontend.

I clicked through the UI views and reviewed the project structure.
The application is built around three main pages:

- Dashboard
- LiveFeed
- UserProfile

Since I come from an Angular background and this project is built with React, I mainly focused on core frontend concepts such as structure, rendering, state management, UI stability, API integration, and error handling.

First, I checked the component structure.
It was clean and modular, but everything sat in one folder, which could get messy as the project grows.

After that, I analyzed state management and data flow.
State lived in the main components and data came from a mock API, then flowed down into the UI.

Then I checked API integration.
API contracts and fetching were in the same file, `mockApi.ts`.
And the API layer handled only happy paths, with no proper loading or error handling.

Then I reviewed each main screen.

On the dashboard, I saw problems with polling cleanup, missing error feedback, and some loading flicker.

On the user profile page, activity loading ran again and again, which caused constant re-rendering.

In the live feed, the backend returned a full new list each time, but the component appended it to the old list instead of replacing it.
That caused duplicate entries.

And across these views, request cancellation or guarding was missing, which could lead to overlapping calls and inconsistent state.

# 12:15 to 14:30 - Frontend Fixes

On screen: `mockApi.ts`, shared API helpers, React effects, and UI states

After identifying the issues, I started to introduce the fixes.

Problem: the API layer handled only happy paths, with no proper loading or error handling.
Fix: First, I added shared API error handling.

- I added `parseErrorMessage(...)` to extract backend `message` values when available
- I added a reusable `fetchJson<T>(path)` helper that checks the backend response and throws a real `Error` on failed requests
- then I switched `fetchTeamStats`, `fetchFeedActivity`, and `fetchUserActivity` to that shared helper

This gave three main benefits:

- centralized request error handling in one place
- preserved backend validation and not-found messages for the UI
- reduced duplicate fetch logic across components

Problem: API contracts and fetching were in the same file, `mockApi.ts`.
Fix: I also externalized the models into `api.model.ts` for better overview and cleaner structure.

Problem: On the user profile page, activity loading ran again and again, which caused constant re-rendering.
Fix: After that, I fixed `UserProfile` so user activity loads only once on mount.
I added `[]` as the dependency array for the activity-loading effect.
Then I added `loading` and `error` state so users get clearer feedback during loading and failure.

Problem: On the dashboard, I saw problems with polling cleanup, missing error feedback, and some loading flicker.
Fix: Then I fixed dashboard auto-refresh cleanup.
I cleared the polling interval when auto-refresh stops, when the selected team changes, and when the component unmounts.
I also added an ignore guard for safe async handling, and added error UI for team stats failures.

Problem: In the live feed, the backend returned a full new list each time, but the component appended it to the old list instead of replacing it.
Fix: Then I changed live feed syncing from append to snapshot replacement.
Instead of adding the new list on top of the old one, the component now replaces it.

Problem: And across these views, request cancellation or guarding was missing, which could lead to overlapping calls and inconsistent state.
Fix: I also added error and loading states to the live feed and introduced request guarding.
I used one effect for both initial loading and refreshing.
The loading state is shown only on the first load, so background polling stays smoother for the user.

# 14:30 to 16:00 - Closing

On screen: final application walkthrough, Postman collection, issue notes, then repository tree

So overall, my goal in this challenge was not only to make the application work, but also to make it more reliable and easier to understand.

On the backend, I focused on correct API behavior, validation, error handling, a cleaner domain model, and better query performance.
On the frontend, I focused on stable state handling, cleaner polling, better API integration, and clearer loading and error feedback.

I also tried to keep the trade-offs explicit.
In some places, I chose the simpler solution because it fit the scope of the challenge, while still keeping the behavior correct.

If I had more time, the next things I would improve are:

- add clearer config profiles for different environments
- move further toward an API-first design with a clearer contract between backend and frontend
- add contract tests for API responses and error cases
- use more DTO projections for backend read endpoints
- add integration tests for backend services and repositories
- add end-to-end tests for the main frontend flows
- improve frontend state handling for polling and async requests
- add a `useDelayedLoading` pattern for smoother loading states
- clean up the frontend structure by separating features, API logic, and reusable UI parts more clearly
- improve logging and make errors easier to trace

What mattered most to me here was the end-to-end review.
Instead of treating the issues as isolated bugs, I looked at the full system: API contract, data model, database behavior, frontend state flow, and user experience.

That is the walkthrough.
Thank you for your time.
