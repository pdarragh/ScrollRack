import Authentication
import FluentMySQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first.
    try services.register(MySQLProvider())
    try services.register(AuthenticationProvider())

    /// Register middleware.
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    /// Register routes to the router.
    let router = EngineRouter.default()
    try buildRoutesForRouter(router)
    services.register(router, as: Router.self)

    /// Extract the database information from the environment.
    let dbHostname = Environment.get("DB_HOSTNAME") ?? "localhost"
    let dbPort = Environment.get("DB_PORT").flatMap { Int($0) } ?? 3306
    let dbUsername = Environment.get("DB_USERNAME") ?? "scrollrack"
    let dbPassword = Environment.get("DB_PASSWORD") ?? "scrollrack"
    let dbName = Environment.get("DB_NAME") ?? "scrollrack"

    /// Configure a MySQL database.
    let config = MySQLDatabaseConfig(
        hostname: dbHostname,
        port: dbPort,
        username: dbUsername,
        password: dbPassword,
        database: dbName,
        capabilities: .default,
        characterSet: .utf8mb4_unicode_ci,
        transport: .unverifiedTLS)
    let mysql = MySQLDatabase(config: config)

    /// Register the configured database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: mysql, as: .mysql)
    services.register(databases)

    /// Configure migrations.
    var migrations = MigrationConfig()
    migrations.add(migration: CreateCard.self, database: .mysql)
    migrations.add(migration: CreateCollection.self, database: .mysql)
    migrations.add(migration: CreateDeckFolder.self, database: .mysql)
    migrations.add(migration: CreateDeck.self, database: .mysql)
    migrations.add(migration: CreateUser.self, database: .mysql)
    migrations.add(migration: CreateUserToken.self, database: .mysql)
    migrations.add(migration: CardsToCollectionsPivot.self, database: .mysql)
    migrations.add(migration: DeckFoldersToDecksPivot.self, database: .mysql)
    migrations.add(migration: DeckFoldersToSubfoldersPivot.self, database: .mysql)
    services.register(migrations)

    /// Set default databases.
    Card.defaultDatabase = .mysql
    Collection.defaultDatabase = .mysql
    DeckFolder.defaultDatabase = .mysql
    Deck.defaultDatabase = .mysql
    User.defaultDatabase = .mysql
    UserToken.defaultDatabase = .mysql
    CardsToCollectionsPivot.defaultDatabase = .mysql
    DeckFoldersToDecksPivot.defaultDatabase = .mysql
    DeckFoldersToSubfoldersPivot.defaultDatabase = .mysql
}
