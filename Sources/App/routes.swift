import Authentication
import Vapor

/// Register your application's routes here.
func buildRoutesForRouter(_ router: Router) throws {
    // Register routes.
    router.get { req in
        return "Hello, world!"
    }

    router.group("api") { api in
        api.group("v1") { v1 in
            // MARK: The /login endpoint provides authentication.
            v1.group(User.basicAuthMiddleware(using: BCryptDigest())) { v1Basic in
                v1Basic.post("login", use: UsersController.login)
            }

            v1.group(User.tokenAuthMiddleware()) { v1Auth in
                // TODO: Remove the /profile endpoint for security.
                v1Auth.get("profile", use: UsersController.findFull)

                v1Auth.group("users") { users in
                    users.get(use: UsersController.index)
                    users.post(CreateUserRequest.self, use: UsersController.create)

                    users.group(Int.parameter) { user in
                        user.get(use: UsersController.find)

                        user.group("cards") { cards in
                            cards.get(use: UserCardsController.index)
                            cards.post(Card.self, use: UserCardsController.create)
                        }

                        user.group("collections") { collections in
                            collections.get(use: UserCollectionsController.index)
                            collections.post(Collection.self, use: UserCollectionsController.create)
                        }

                        user.group("deck_folders") { deckFolders in
                            deckFolders.get(use: UserDeckFoldersController.index)
                            deckFolders.post(DeckFolder.self, use: UserDeckFoldersController.create)
                        }

                        user.group("decks") { decks in
                            decks.get(use: UserDecksController.index)
                        }
                    }
                }
            }
        }
    }
}
