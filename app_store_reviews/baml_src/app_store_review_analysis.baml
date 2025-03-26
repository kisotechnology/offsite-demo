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

// Function to analyze app store reviews
function AnalyzeAppReview(review: string) -> ReviewAnalysis {
  client "openai/gpt-4o"
  prompt #"
    {{_.role("user")}}
    You are an expert at analyzing app store reviews to extract structured insights. Your task is to analyze the following app review and extract key information in a structured format.

    App review: {{review}}

    Please analyze this review and extract the following information:
    1. The overall sentiment (positive, negative, or neutral)
    2. The intensity of the sentiment (low, medium, high, or null if not discernible)
    3. Any actions the user has taken or threatens to take
    4. Topics mentioned in the review along with specific subtopics

    Provide your analysis with precision - only include information that is explicitly stated or strongly implied.

    {{ctx.output_format}}
  "#
}

// Ground truth dataset for evaluation
test positive_review_1 {
  functions [AnalyzeAppReview]
  args {
    review #"
      I love this app! It's been a great way to meet new people in my area. The interface is super intuitive and the matching algorithm seems spot on. I've been using it for about 3 months now and have made some great connections. Highly recommend to anyone looking to meet new people.
    "#
  }
}

test positive_review_2 {
  functions [AnalyzeAppReview]
  args {
    review #"
      Pretty good app overall. I've had a few minor glitches with notifications but nothing major. Customer service was responsive when I had a question about my subscription. I'll definitely keep using it.
    "#
  }
}

test negative_review_1 {
  functions [AnalyzeAppReview]
  args {
    review #"
      This app is terrible and I've already uninstalled it. The chat feature never works properly - messages are constantly delayed or sent twice. I contacted support multiple times but never got a real solution. Save your money and time and look elsewhere.
    "#
  }
}

test negative_review_2 {
  functions [AnalyzeAppReview]
  args {
    review #"
      I'm going to uninstall this app if the bugs aren't fixed in the next update. Ever since the last update, the app crashes whenever I try to upload photos. I've also been charged twice for my premium subscription and have requested a refund. Very disappointing as I used to love this app.
    "#
  }
}

test neutral_review_1 {
  functions [AnalyzeAppReview]
  args {
    review #"
      The app has some good features but also some drawbacks. I like the profile customization options and the variety of filters. However, the matching algorithm could use some work as I often get suggested profiles that don't match my preferences. I'm on the fence about renewing my subscription.
    "#
  }
}

test negative_review_3 {
  functions [AnalyzeAppReview]
  args {
    review #"
      I've paused usage of the app because of all the ads. It's ridiculous how many ads pop up every few minutes. I understand needing to monetize but this is excessive. I'm also having issues with the payment system - tried to upgrade to premium to remove ads but my card was declined even though it works everywhere else. Fix these issues and I might come back.
    "#
  }
}

test mixed_review_1 {
  functions [AnalyzeAppReview]
  args {
    review #"
      I've been using this app for 2 years now. It used to be amazing but the recent updates have made the experience worse. The new design is confusing and there are new bugs in the messaging system. However, I still think it has the best community of any dating app and the events feature is really cool. I've recommended it to friends despite the issues.
    "#
  }
}

test detailed_issue_review {
  functions [AnalyzeAppReview]
  args {
    review #"
      I've contacted support twice about this already but no response. The app keeps logging me out every few hours and I have to reset my password each time because the normal login doesn't work. I've wasted so much time with this. If this isn't fixed soon I'm going to switch to a competitor app and ask for my subscription money back. Such a basic feature should work properly!
    "#
  }
}

test feature_request_review {
  functions [AnalyzeAppReview]
  args {
    review #"
      Decent app but could be better with a few changes. I wish there was a dark mode option for night use. Also, it would be great if you could schedule messages to be sent later. Otherwise works as expected and I haven't had any major issues.
    "#
  }
}

test specific_action_review {
  functions [AnalyzeAppReview]
  args {
    review #"
      I've downgraded my subscription from premium to basic because the premium features aren't worth the extra cost. The only difference seems to be seeing who liked you first, which isn't that helpful. The matchmaking algorithm is still good though, and I've had no technical issues.
    "#
  }
}

test recommendation_review {
  functions [AnalyzeAppReview]
  args {
    review #"
      I've told all my friends to avoid this app. It's overpriced and the free version is basically useless. You can't even see who messaged you without paying. Plus, there are so many fake profiles it's ridiculous. I've reported dozens but they keep appearing. Complete waste of time.
    "#
  }
}