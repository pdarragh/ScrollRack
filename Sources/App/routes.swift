import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Configure controllers.
    let userCardsController = UserCardsController()
    let userCollectionsController = UserCollectionsController()
    let userDeckFoldersController = UserDeckFoldersController()
    let userDecksController = UserDecksController()
    let usersController = UsersController()

    // Register routes.
    router.get { req in
        return "Hello, world!"
    }

    router.group("api") { api in
        api.group("v1") { v1 in
            v1.group("users") { users in
                users.get(use: usersController.index)
                users.post(use: usersController.create)

                users.group(Int.parameter) { user in
                    user.get(use: usersController.find)

                    user.group("cards") { cards in
                        cards.get(use: userCardsController.index)
                    }

                    user.group("collections") { collections in
                        collections.get(use: userCollectionsController.index)
                    }

                    user.group("deck_folders") { deckFolders in
                        deckFolders.get(use: userDeckFoldersController.index)
                    }

                    user.group("decks") { decks in
                        decks.get(use: userDecksController.index)
                    }
                }
            }
        }
    }
}
