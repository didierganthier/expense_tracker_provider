import 'package:expense_tracker_provider/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exepense Tracker'),
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, child) {
          return ListView.builder(
            itemCount: expenseProvider.expenses.length,
            itemBuilder: (context, index) {
              final expense = expenseProvider.expenses[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(expense.priority.toString()),
                  ),
                  title: Text(expense.title),
                  subtitle:
                      Text('${expense.category} - ${expense.date.toLocal()}'),
                  trailing: Text('\$${expense.amount.toStringAsFixed(2)}'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String title = '';
              String category = '';
              double amount = 0.0;
              int priority = 1;
              DateTime date = DateTime.now();

              return AlertDialog(
                title: Text('Add New Expense'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(labelText: 'Title'),
                        onChanged: (value) {
                          title = value;
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Category'),
                        onChanged: (value) {
                          category = value;
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Amount'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          amount = double.tryParse(value) ?? 0.0;
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Priority'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          priority = int.tryParse(value) ?? 1;
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Date'),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              date = pickedDate;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (title.isNotEmpty &&
                          category.isNotEmpty &&
                          amount > 0) {
                        Provider.of<ExpenseProvider>(context, listen: false)
                            .addExpense(
                          title,
                          amount,
                          date,
                          category,
                          priority,
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
