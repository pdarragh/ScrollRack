import FluentMySQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first.
    try services.register(MySQLProvider())

    /// Register routes to the router.
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware.
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    /// Extract the database password from the environment.
    guard let dbPassword = Environment.get("DB_PASSWORD") else {
        throw Abort(.internalServerError)
    }

    /// Configure a MySQL database.
    let config = MySQLDatabaseConfig(
        hostname: "localhost",
        port: 3306,
        username: "mtginv",
        password: dbPassword,
        database: "mtg_inventory_test",
        capabilities: .default,
        characterSet: .utf8mb4_unicode_ci,
        transport: .unverifiedTLS)
    let mysql = MySQLDatabase(config: config)

    /// Register the configured SQLite database to the database config.
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
    services.register(migrations)

    /// Set default databases.
    Card.defaultDatabase = .mysql
    Collection.defaultDatabase = .mysql
    DeckFolder.defaultDatabase = .mysql
    Deck.defaultDatabase = .mysql
    User.defaultDatabase = .mysql
}
