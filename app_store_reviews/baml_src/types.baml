// App Review Analysis BAML Implementation

enum Sentiment {
  POSITIVE @description("The review expresses overall satisfaction or approval with the app")
  NEGATIVE @description("The review expresses overall dissatisfaction or disapproval with the app")
  NEUTRAL @description("The review is neither clearly positive nor negative, or contains a balanced mix of both")
}

enum SentimentIntensity {
  LOW @description("Mild or subtle emotional tone")
  MEDIUM @description("Moderate emotional tone")
  HIGH @description("Strong or intense emotional tone")
  NULL @description("No discernible emotional intensity")
}

class ReviewTopic {
  topic string @description("The main feature or aspect of the app being discussed (e.g., 'chat', 'billing', 'profile', 'matching')")
  subtopics string[] @description("Specific aspects of the main topic (e.g., for 'chat': ['message delay', 'double sending'])")
}

class ReviewAnalysis {
  sentiment Sentiment @description("The overall sentiment of the review")
  sentiment_intensity SentimentIntensity @description("The intensity of the sentiment expressed in the review")
  user_actions string[] @description("Actions the user has taken or threatens to take, such as 'threatened uninstall', 'already uninstalled', 'requested refund', etc.")
  topics ReviewTopic[] @description("Topics mentioned in the review, with each topic having a list of subtopics")
}