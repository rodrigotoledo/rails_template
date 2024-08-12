# Docker Instructions

Need To Clean All Your Docker?

```bash
docker system prune -a --volumes -f
```

## Putting In Development Mode

Whereas It Is Necessary To Run With Your User, Run

```bash
id -u
```

And Change The Dockerfile.Development File With The Value You Found

So Build You Just Need To Run The First Time:

```bash
docker compose -f docker-compose.development.yml build
```

And To Climb The Application Rode:

```bash
docker compose -f docker-compose.development.yml up
```

## Migrations

To Run Migrations, Tests ... Etc, Run The App With Whatever Is Needed:

```bash
docker compose -f docker-compose.development.yml run app rails db:drop db:create db:migrate
```

## Rails Commands

Example Of Interaction Between Computer And Container:

```bash
docker compose -f docker-compose.development.yml run app rails d model comment
docker compose -f docker-compose.development.yml run app rails g model comment post:references comment:text
docker compose -f docker-compose.development.yml run app rails c
```

## Testing

For Tests For Example Run `Guard`:

```bash
docker compose -f docker-compose.development.yml run app bundle exec guard
```

For Migrations (Remembering That You May Need To Run Both In Development And Test):

```bash
docker compose -f docker-compose.development.yml run app rails db:migrate
```

## Putting Down

If You Want To Stop The Services:

```bash
docker compose -f docker-compose.development.yml down
```

## More

Ruby On Rails With Docker And Docker-Compose In Development Mode

Usually There Are Questions And Details On How To Develop Using Docker And Docker-Compose In Development Mode: I Need To Build, Go Up And Down All The Time ... Calm Down Let's Go
