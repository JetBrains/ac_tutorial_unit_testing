//
//  iOSConferencesTests.swift
//  iOSConferencesTests
//
//  Created by Marianna Kononenko on 22.06.20.
//  Copyright © 2020 JetBrains. All rights reserved.
//

import XCTest
import Yams
@testable import iOSConferences

class DateTests: XCTestCase {
    let decoder = YAMLDecoder()
    func testSameStartEndDatesShownCorrectly() {
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
        let textDate = conference.textDates()
        XCTAssertEqual(textDate, "May 30, 2019")

    }

    func testDateWithoutEndShownCorrectly() {
        let yaml = try! decoder.decode([Conference].self, from:
        """
        - name: mDevCamp
          link: https://mdevcamp.eu/
          start: 2019-05-30
          location: 🇨🇿 Prague, Czech Republic
        """
        )
        let conference: Conference = yaml[0]
        let textDate = conference.textDates()
        XCTAssertEqual(textDate, "May 30, 2019")
    }

    func testEndEarlierThanStartReplaced() {
        let yaml = try! decoder.decode([Conference].self, from:
        """
        - name: mDevCamp
          link: https://mdevcamp.eu/
          start: 2019-05-30
          end: 2019-05-29
          location: 🇨🇿 Prague, Czech Republic
        """
        )
        let conference: Conference = yaml[0]
        let textDate = conference.textDates()
        XCTAssertEqual(textDate, "May 29, 2019 - May 30, 2019")
    }

}
