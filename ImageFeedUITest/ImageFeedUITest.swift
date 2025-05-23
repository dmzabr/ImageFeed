//
//  ImageFeedUITest.swift
//  ImageFeedUITest
//
//  Created by  Дмитрий on 24.05.2025.
//

import XCTest

import XCTest

final class ImageFeedUITest: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
        
    func testAuth() throws {
            app.buttons["Войти"].tap()

            let webView = app.webViews["UnsplashWebView"]
            XCTAssertTrue(webView.waitForExistence(timeout: 30), "WebView не загрузился")

            let loginTextField = webView.textFields.element
            XCTAssertTrue(loginTextField.waitForExistence(timeout: 10), "Поле логина не найдено")
            loginTextField.tap()
            loginTextField.typeText("shabunkina.l@gmail.com")

            XCTAssertTrue(app.buttons["Done"].waitForExistence(timeout: 5), "Кнопка Done не найдена")
            app.buttons["Done"].tap()

            let passwordTextField = webView.secureTextFields.element
            XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10), "Поле пароля не найдено")
            passwordTextField.tap()
            passwordTextField.typeText("Iecnh256!")

            if app.buttons["Done"].exists {
                app.buttons["Done"].tap()
            }
            XCTAssertTrue(webView.buttons["Login"].waitForExistence(timeout: 10), "Кнопка логина не найдена")
            webView.buttons["Login"].tap()

            let cell = app.tables.cells.element(boundBy: 0)
            XCTAssertTrue(cell.waitForExistence(timeout: 15), "Лента не загрузилась")
        }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let firstCell = tablesQuery.cells.element(boundBy: 0)

        XCTAssertTrue(firstCell.waitForExistence(timeout: 10), "Лента не загрузилась")

        firstCell.swipeUp()

        let secondCell = tablesQuery.cells.element(boundBy: 1)
        XCTAssertTrue(secondCell.waitForExistence(timeout: 5), "Вторая ячейка не найдена")

        let likeButton = secondCell.buttons["like button off"]
        let likedButton = secondCell.buttons["like button on"]

        if likeButton.exists && likeButton.isHittable {
            likeButton.tap()

            let predicate = NSPredicate(format: "exists == false")
            expectation(for: predicate, evaluatedWith: likeButton, handler: nil)
            waitForExpectations(timeout: 5)

            XCTAssertTrue(likedButton.exists, "Кнопка после лайка не появилась")
            likedButton.tap()
        } else if likedButton.exists && likedButton.isHittable {
            likedButton.tap()

            let predicate = NSPredicate(format: "exists == false")
            expectation(for: predicate, evaluatedWith: likedButton, handler: nil)
            waitForExpectations(timeout: 5)

            let unlikedButton = secondCell.buttons["like button off"]
            XCTAssertTrue(unlikedButton.exists, "Кнопка после дизлайка не появилась")
        } else {
            XCTFail("Ни одна кнопка лайка не найдена или не доступна для нажатия")
        }
    }
    
    func testProfile() throws {
        let firstCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10), "Лента не загрузилась")
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Lyubov Shabunkina"].exists)
        XCTAssertTrue(app.staticTexts["@shabunkina_l"].exists)
        
        app.buttons["logout button"].tap()
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(2)
        let authButton = app.buttons["Authenticate"]
        XCTAssertTrue(authButton.waitForExistence(timeout: 5), "Кнопка авторизации не появилась после выхода")
    }
}
