import Foundation


let responseData = """
{
    "messages": [],
    "result": {
        "response": "Here's a possible app description for the app store page of your game, BimBom:\\n\\n**BimBom: The Ultimate Fun Game**\\n\\n**Get Ready for a Blast of Fun!**\\n\\nJoin the BimBom revolution and experience the most entertaining game of the year!\\n\\nImmerse yourself in a world of exciting adventures, brain-teasers, and colorful graphics. BimBom is a fun game designed to bring a smile to your face and challenge your skills.\\n\\n**Features:**\\n\\n* Engaging gameplay with increasing levels of difficulty\\n* Colorful, vibrant graphics that will transport you to a world of wonder\\n* Simple to learn, but challenging to master\\n* Share your progress and compete with friends on the leaderboards\\n* Regular updates with new levels and puzzles to keep you entertained\\n\\n**What are you waiting for? Download BimBom now and start having fun!**\\n\\n**Note:** This is just a sample, and you can customize it to fit your game's unique features and personality."
    },
    "errors": [],
    "success": 1
}
""".data(using: .utf8)!

struct APIResponse: Codable {
    struct Result: Codable {
        let response: String
    }
    let result: Result
}
