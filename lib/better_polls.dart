library better_polls;

import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

typedef PollCallBack = void Function(int choice);

typedef PollTotal = void Function(int total);

late int userPollChoice;

class Polls extends StatefulWidget {
  /// this takes the question on the poll
  final Text question;

  ///this determines what type of view user should see
  ///if its creator, or view requiring you to vote or view showing your vote
  final PollsType? viewType;

  ///this takes in vote data which should be a Map
  /// with this, polls widget determines what type of view the user should see
  final Map<String, int>? voteData;

  final String? currentUser;

  final String? creatorID;

  /// this takes in poll options array
  final List<PollOption> children;

  /// this call back returns user choice after voting
  final PollCallBack? onVote;

  /// this is takes in current user choice
  final int? userChoice;

  /// this determines if the creator of the poll can vote or not
  final bool allowCreatorVote;

  /// this returns total votes casted
  final PollTotal? getTotal;

  /// this returns highest votes casted
  final PollTotal? getHighest;

  @protected
  final double? highest;

  /// style
  final TextStyle? pollStyle;
  final TextStyle? leadingPollStyle;

  ///colors setting for polls widget
  final Color outlineColor;
  final Color backgroundColor;
  final Color? onVoteBackgroundColor;
  final Color? iconColor;
  final Color? leadingBackgroundColor;

  /// Polls contruct by default get view for voting
  const Polls({
    Key? key,
    required this.children,
    required this.question,
    required this.voteData,
    required this.currentUser,
    required this.creatorID,
    this.userChoice,
    this.allowCreatorVote = false,
    this.onVote,
    this.outlineColor = Colors.blue,
    this.backgroundColor = Colors.blueGrey,
    this.onVoteBackgroundColor = Colors.blue,
    this.leadingPollStyle,
    this.pollStyle,
    this.iconColor = Colors.black,
    this.leadingBackgroundColor = Colors.blueGrey,
  })  : highest = null,
        getHighest = null,
        getTotal = null,
        viewType = null,
        assert(onVote != null),
        assert(voteData != null),
        assert(currentUser != null),
        assert(creatorID != null),
        super(key: key);

  /// Polls.option is used to set polls options
  static PollOption options({required String title, required double value}) {
    return PollOption(name: title, value: value);
  }

  /// this creates view for see polls result
  const Polls.viewPolls({
    Key? key,
    required this.children,
    required this.question,
    this.userChoice,
    this.leadingPollStyle,
    this.pollStyle,
    this.backgroundColor = Colors.blue,
    this.leadingBackgroundColor = Colors.blueAccent,
    this.onVoteBackgroundColor = Colors.blueGrey,
    this.iconColor = Colors.black,
  })  : allowCreatorVote = false,
        getTotal = null,
        highest = null,
        voteData = null,
        currentUser = null,
        creatorID = null,
        getHighest = null,
        outlineColor = Colors.transparent,
        viewType = PollsType.readOnly,
        onVote = null,
        super(key: key);

  /// This creates view for the creator of the polls
  const Polls.creator({
    Key? key,
    required this.children,
    required this.question,
    this.leadingPollStyle,
    this.pollStyle,
    this.backgroundColor = Colors.blue,
    this.leadingBackgroundColor = Colors.blueAccent,
    this.onVoteBackgroundColor = Colors.blueGrey,
    this.allowCreatorVote = false,
  })  : viewType = PollsType.creator,
        onVote = null,
        userChoice = null,
        highest = null,
        getHighest = null,
        voteData = null,
        currentUser = null,
        creatorID = null,
        getTotal = null,
        iconColor = null,
        outlineColor = Colors.transparent,
        super(key: key);

  /// this creates view for users to cast votes
  const Polls.castVote({
    Key? key,
    required this.children,
    required this.question,
    required this.onVote,
    this.allowCreatorVote = false,
    this.outlineColor = Colors.blue,
    this.backgroundColor = Colors.blueGrey,
    this.pollStyle,
  })  : viewType = PollsType.voter,
        userChoice = null,
        highest = null,
        getHighest = null,
        getTotal = null,
        iconColor = null,
        voteData = null,
        currentUser = null,
        creatorID = null,
        leadingBackgroundColor = null,
        leadingPollStyle = null,
        onVoteBackgroundColor = null,
        assert(onVote != null),
        super(key: key);

  @override
  _PollsState createState() => _PollsState();
}

class _PollsState extends State<Polls> {
  @protected
  List<String> choiceNames = [];

  @protected
  List<double> choiceValues = [];

  /// style
  late TextStyle pollStyle;
  late TextStyle leadingPollStyle;

  ///colors setting for polls widget
  Color? outlineColor;
  Color? backgroundColor;
  Color? onVoteBackgroundColor;
  Color? iconColor;
  Color? leadingBackgroundColor;

  late double highest;

  @override
  void initState() {
    super.initState();

    /// if polls style is null, it sets default pollstyle and leading pollstyle
    pollStyle = widget.pollStyle == null
        ? const TextStyle(color: Colors.black, fontWeight: FontWeight.w300)
        : pollStyle;
    leadingPollStyle = widget.leadingPollStyle == null
        ? const TextStyle(color: Colors.black, fontWeight: FontWeight.w800)
        : leadingPollStyle;

    for (int i = 0; i < widget.children.length; i++) {
      choiceNames.add(widget.children[i].name);
      choiceValues.add(widget.children[i].value);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.viewType == null) {
      var viewType = (widget.voteData?.containsKey(widget.currentUser) ?? false)
          ? PollsType.readOnly
          : widget.currentUser == widget.creatorID
              ? PollsType.creator
              : PollsType.voter;
      if (viewType == PollsType.voter) {
        //user can cast vote with this widget
        return voterWidget(context);
      }
      if (viewType == PollsType.creator) {
        //mean this is the creator of the polls and cannot vote
        if (widget.allowCreatorVote) {
          return voterWidget(context);
        }
        return pollCreator(context);
      }

      if (viewType == PollsType.readOnly) {
        //user can view his votes with this widget
        return voteCasted(context);
      }
    } else {
      if (widget.viewType == PollsType.voter) {
        //user can cast vote with this widget
        return voterWidget(context);
      }
      if (widget.viewType == PollsType.creator) {
        //mean this is the creator of the polls and cannot vote
        if (widget.allowCreatorVote) {
          return voterWidget(context);
        }
        return pollCreator(context);
      }

      if (widget.viewType == PollsType.readOnly) {
        //user can view his votes with this widget
        return voteCasted(context);
      }
    }
    return Container();
  }

  /// voterWidget creates view for users to cast their votes

  Widget voterWidget(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget.question,
        const SizedBox(
          height: 12,
        ),
        ...widget.children
            .mapIndexed(
              (ind, _) => Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  margin: const EdgeInsets.all(0),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(0),
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: widget.backgroundColor,
                  ),
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        userPollChoice = ind;
                      });
                      widget.onVote!(userPollChoice);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(widget.backgroundColor),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(5.0)),
                      side: MaterialStateProperty.all(
                        BorderSide(
                          color: widget.outlineColor,
                        ),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: Text(choiceNames[ind], style: widget.pollStyle),
                  ),
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  /// pollCreator creates view for the creator of the polls,
  /// to see poll activities
  Widget pollCreator(context) {
    double current = 0;

    for (var i = 0; i < choiceValues.length; i++) {
      double s = double.parse(choiceValues[i].toString());

      if ((choiceValues[i]) >= current) {
        current = s;
      }
    }

    highest = current;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget.question,
        const SizedBox(
          height: 12,
        ),
        ...widget.children.mapIndexed(
          (ind, _) {
            bool isHighest = highest == choiceValues[ind];
            return Container(
              margin: const EdgeInsets.fromLTRB(3, 3, 10, 3),
              width: double.infinity,
              child: LinearPercentIndicator(
                animation: true,
                lineHeight: 38.0,
                animationDuration: 500,
                percent: PollMath.getPercent(choiceValues, ind),
                center: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          choiceNames[ind],
                          style: isHighest
                              ? widget.leadingPollStyle
                              : widget.pollStyle,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    Text(
                        PollMath.getMainPercent(
                              choiceValues,
                              ind,
                            ).toString() +
                            "%",
                        style: isHighest
                            ? widget.leadingPollStyle
                            : widget.pollStyle)
                  ],
                ),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: isHighest
                    ? widget.leadingBackgroundColor
                    : widget.onVoteBackgroundColor,
              ),
            );
          },
        ).toList(),
      ],
    );
  }

  /// voteCasted created view for user to see votes they casted including other peoples vote
  Widget voteCasted(context) {
    double current = 0;
    for (var i = 0; i < choiceValues.length; i++) {
      double s = double.parse(choiceValues[i].toString());
      if ((choiceValues[i]) >= current) {
        current = s;
      }
    }

    highest = current;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget.question,
        const SizedBox(
          height: 12,
        ),
        ...widget.children.mapIndexed(
          (int ind, _) {
            bool isHighest = highest == choiceValues[ind];
            return Container(
              margin: const EdgeInsets.fromLTRB(3, 3, 10, 3),
              width: double.infinity,
              child: LinearPercentIndicator(
                animation: true,
                lineHeight: 38.0,
                animationDuration: 500,
                percent: PollMath.getPercent(choiceValues, ind),
                center: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          choiceNames[ind].toString(),
                          style: isHighest
                              ? widget.leadingPollStyle
                              : widget.pollStyle,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        myOwnChoice(widget.userChoice == ind)
                      ],
                    ),
                    Text(
                      PollMath.getMainPercent(choiceValues, ind).toString() +
                          "%",
                      style: isHighest
                          ? widget.leadingPollStyle
                          : widget.pollStyle,
                    )
                  ],
                ),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: isHighest
                    ? widget.leadingBackgroundColor
                    : widget.onVoteBackgroundColor,
              ),
            );
          },
        ).toList(),
      ],
    );
  }

  /// simple logic to detect users choice and return a check icon
  Widget myOwnChoice(choice) {
    if (choice) {
      return const Icon(
        Icons.check_circle_outline,
        color: Colors.white,
        size: 17,
      );
    } else {
      return Container();
    }
  }
}

/// Help detect type of view user wants
enum PollsType {
  creator,
  voter,
  readOnly,
}

/// Handles the math for the percentages of the polls.
class PollMath {
  static double getMainPercent(List<double> choiceValues, int choice) {
    double div = choiceValues.sum == 0
        ? 0
        : (100 / choiceValues.sum) * choiceValues[choice];
    return div == 0 ? 0 : div.round().toDouble();
  }

  static double getPercent(List<double> choiceValues, int choice) {
    double div = choiceValues.sum == 0
        ? 0
        : (1 / choiceValues.sum) * choiceValues[choice];
    return div.toDouble();
  }
}

class PollOption {
  final String name;
  final double value;

  PollOption({
    required this.name,
    required this.value,
  });
}
