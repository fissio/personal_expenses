import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense/models/transaction.dart';

class TransactionList extends StatelessWidget {
  const TransactionList(this.transaction, this.deleteTx, {Key? key})
      : super(key: key);

  final List<Transaction> transaction;
  final Function deleteTx;

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: MediaQuery.of(context).size.height * 0.6,
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: transaction.isEmpty
          ? LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Text(
                    'No transactions available yet!',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            })
          : ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.purple,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: FittedBox(
                          child: Text(
                            '\$${transaction[index].amount?.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      transaction[index].title.toString(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd().format(transaction[index].date!),
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    trailing: MediaQuery.of(context).size.width > 400
                        ? TextButton.icon(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.red)),
                            onPressed: () {
                              deleteTx(transaction[index].id);
                            },
                            icon: const Icon(Icons.delete),
                            label: const Text('Delete'))
                        : IconButton(
                            onPressed: () {
                              deleteTx(transaction[index].id);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                  ),
                );
                // return Card(
                //   child: Row(
                //     children: [
                //       Container(
                //         width: MediaQuery.of(context).size.width * 0.3,
                //         margin: const EdgeInsets.symmetric(
                //             vertical: 10, horizontal: 10),
                //         child: Text(
                //           '\$${transaction[index].amount?.toStringAsFixed(2)}',
                //           style: Theme.of(context).textTheme.titleLarge,
                //           textAlign: TextAlign.center,
                //         ),
                //         decoration: BoxDecoration(
                //           border: Border.all(
                //               color: Theme.of(context).colorScheme.primary),
                //         ),
                //         padding: const EdgeInsets.all(20),
                //       ),
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             transaction[index].title.toString(),
                //             style: Theme.of(context).textTheme.titleLarge,
                //           ),
                //           Text(
                //             DateFormat.yMMMd().format(transaction[index].date!),
                //             style: Theme.of(context).textTheme.subtitle1,
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // );
              },
              itemCount: transaction.length,
            ),
    );
  }
}
