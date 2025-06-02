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

        let email = webView.textFields["Email address"]
        XCTAssertTrue(email.waitForExistence(timeout: 5))
        email.tap()
        email.typeText("dzabrik@yandex.ru")

        XCTAssertTrue(app.buttons["Готово"].waitForExistence(timeout: 5), "Кнопка Готово не найдена")
        app.buttons["Готово"].tap()
        let password = webView.secureTextFields["Password"]

        XCTAssertTrue(password.waitForExistence(timeout: 5))
        password.tap()
        sleep(1)
        password.typeText("meGzyk-jokgu3-dimtyv")
//        let passwordTextField = webView.secureTextFields.element
//        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10), "Поле пароля не найдено")
//        passwordTextField.tap()
//        passwordTextField.typeText("meGzyk-jokgu3-dimtyv")

//        if app.buttons["go"].exists {
//            app.buttons["go"].tap()
//        }
        XCTAssertTrue(webView.buttons["Login"].waitForExistence(timeout: 10), "Кнопка логина не найдена")
        webView.buttons["Login"].tap()

        let cell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 15), "Лента не загрузилась")
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let firstCell = tablesQuery.cells.element(boundBy: 0)

        XCTAssertTrue(firstCell.waitForExistence(timeout: 10), "Лента не загрузилась")

//        firstCell.swipeUp()

        let secondCell = tablesQuery.cells.element(boundBy: 1)
        XCTAssertTrue(secondCell.waitForExistence(timeout: 5), "Вторая ячейка не найдена")

        let likeButton = secondCell.buttons["like button off"]
        let likedButton = secondCell.buttons["like button on"]

        if likeButton.exists {
            likeButton.tap()

            let predicate = NSPredicate(format: "exists == false")
            expectation(for: predicate, evaluatedWith: likeButton, handler: nil)
            waitForExpectations(timeout: 5)

            XCTAssertTrue(likedButton.exists, "Кнопка после лайка не появилась")
            likedButton.tap()
        } else if likedButton.exists {
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
        
        XCTAssertTrue(app.staticTexts["Dmitriy Zabrodskiy"].exists)
        XCTAssertTrue(app.staticTexts["@dmzabr"].exists)
        
        app.buttons["logout button"].tap()
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(2)
        let authButton = app.buttons["Login"]
        XCTAssertTrue(authButton.waitForExistence(timeout: 5), "Кнопка авторизации не появилась после выхода")
    }
}
