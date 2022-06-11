# Polls

[![pub package](https://img.shields.io/badge/pub-1.0.0-brightgreen)](https://pub.dev/packages/better_polls)


[GitHub](https://github.com/tjcampanella/better_polls)

## ScreenShots

| Voting | Not Voted Yet | Voted |
| ------------- | ------------- | ------------- |
| <image width="200" src="https://raw.githubusercontent.com/samuelezedi/polls/master/example/assets/3.gif"> | <image width="200" src="https://raw.githubusercontent.com/samuelezedi/polls/master/example/assets/1.jpeg"> | <image width="200" src="https://raw.githubusercontent.com/samuelezedi/polls/master/example/assets/2.jpeg"> |


## Usage

Basic:

```dart
import 'package:better_polls/better_polls.dart';
```

```dart
Polls(
    children: [
        // This cannot be less than 2, else will throw an exception
        Polls.options(title: 'Cairo', value: option1),
        Polls.options(title: 'Mecca', value: option2),
        Polls.options(title: 'Denmark', value: option3),
        Polls.options(title: 'Mogadishu', value: option4),
        ],
        question: Text('What is the capital of Egypt'),
        currentUser: user,
        creatorID: creator,
        voteData: usersWhoVoted,
        userChoice: usersWhoVoted[user],
        onVoteBackgroundColor: Colors.blue,
        leadingBackgroundColor: Colors.blue,
        backgroundColor: Colors.white,
        onVote: (choice) {

            setState(() {
              usersWhoVoted[user] = choice;
            });
            if (choice == 1) {
            setState(() {
                option1 += 1.0;
            });
            }
            if (choice == 2) {
            setState(() {
                option2 += 1.0;
            });
            }
            if (choice == 3) {
            setState(() {
                option3 += 1.0;
            });
            }
            if (choice == 4) {
            setState(() {
                option4 += 1.0;
            });
        }
    },
);
```

### Poll View type

```dart
Polls(
  viewType: PollsType.creator
);
```

```dart
Polls(
viewType: PollsType.voter
);
```


```dart
Polls(
viewType: PollsType.readOnly
);
```


## Why we forked the original polls package

We initially forked the package to update the package for Flutter 3, after the orignal package was not updated for months. 
After diving into the code, we noticed many design issues and it gave us even more of a reason to fork the package.
Our version now includes various improvements on structure and overall code cleanliness. Some of the enhancements, include
reduction in line count from 1500 to 500, remove redundant code, add ability to add unlimited polls, and overall maintainability 
improvements.