//
//  ApiTests.swift
//  iOSConferences
//
//  Created by Marianna Kononenko on 22.06.20.
//  Copyright © 2020 JetBrains. All rights reserved.
//

import XCTest
import Yams
import Quick
import Nimble
@testable import iOSConferences

class ApiTests: QuickSpec {

    override func spec() {
        describe("Application") {
            let decoder = YAMLDecoder()
            let loader = ConferencesLoader()

            it("should load conferences") {
                waitUntil(timeout: 5) { done in
                    loader.loadConferences { conferences in
                        done()
                    }
                }
            }

            it("should parse conference") {
                let yaml = try! decoder.decode([Conference].self, from:
                """
                - name: mDevCamp
                  link: https://mdevcamp.eu/
                  start: 2019-05-30
                  end: 2019-05-30
                  location: 🇨🇿 Prague, Czech Republic
                """
                )
                let conference: Conference = yaml[0]
                expect(conference.end).toNot(beNil())
                expect(conference.name).to(equal("mDevCamp"))
                expect(conference.start).toNot(beNil())
                expect(conference.location).to(equal("🇨🇿 Prague, Czech Republic"))
                expect(conference.link).to(equal("https://mdevcamp.eu/"))
            }

            it("should ignore unused fields") {
                let yaml = try! decoder.decode([Conference].self, from:
                """
                - name: mDevCamp
                  link: https://mdevcamp.eu/
                  start: 2019-05-30
                  end: 2019-05-30
                  location: 🇨🇿 Prague, Czech Republic
                  cocoa-only: true
                  cfp:
                    link: https://www.papercall.io/swift-to-2020
                    deadline: 2020-06-16
                """
                )
                let conference: Conference = yaml[0]
                expect(conference.end).toNot(beNil())
                expect(conference.name).to(equal("mDevCamp"))
                expect(conference.start).toNot(beNil())
                expect(conference.location).to(equal("🇨🇿 Prague, Czech Republic"))
                expect(conference.link).to(equal("https://mdevcamp.eu/"))
            }
        }
    }
}
