import Foundation

extension String {
    static func getDayAddition(int: Int) -> String {
        let preLastDigit = int % 100 / 10
        if preLastDigit == 1 { return "дней" }
        switch (int % 10) {
        case 1: return "день"
        case 2, 3, 4: return "дня"
        default: return "дней"
        }
    }
}
