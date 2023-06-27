# Let's Chat

What if there was a way to deal with stress that was only a chat away, and help was always available? “Let’s Chat” is an iOS chat app that connects users with a friendly, supportive AI chatbot. This chatbot offers understanding, empathy and useful advice for managing stress right on their device.

Many people across the world face stress, leading to different mental and physical health problems. Talking about these problems can be difficult for some, impossible for others because of factors like stigma, lack of support, and fear of burdening others. This problem needs to be solved in an accessible way for different needs, providing users with a supportive environment where they feel comfortable sharing their concerns. 

My solution is “Let’s Chat”, an iOS app connecting users with an AI buddy using GPT-3 technology to provide personalized conversations that help users understand and manage their stress. By offering empathy, understanding and practical advice, the AI buddy creates a safe environment for users to share their stress and experiences.

## Adding API Key

To store the API key, we will be using a plist file named `Secrets.plist`. This file should be created in the project's root directory, but it is important to ensure that it is not included in the repository.

### Creating Secrets.plist

Follow these steps to create the `Secrets.plist` file:

1. Open a text editor or Xcode's Property List Editor.
2. Create a new file and save it as `Secrets.plist` in the root directory of your project.
3. Define a key-value pair in the plist file with the key "APIKey" and the corresponding value being your API key.

### Ignoring Secrets.plist

To prevent the `Secrets.plist` file from being committed to the repository, add it to your `.gitignore` file. If the `.gitignore` file does not exist, create one in the root directory of your project and add the following line:

### Important Note

- Keep the `Secrets.plist` file secure and do not share it publicly.
- Treat the file as sensitive information and avoid committing it to public/private repositories all time.

