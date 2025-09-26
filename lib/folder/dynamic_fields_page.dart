import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'folder/bloc/dynamic_fields_bloc.dart';
import 'folder/bloc/dynamic_fields_event.dart';
import 'folder/bloc/dynamic_fields_state.dart';

class DynamicFieldsPage extends StatelessWidget {
  const DynamicFieldsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DynamicFieldsBloc(),
      child: const DynamicFieldsView(), // ✅ separate child widget
    );
  }
}

class DynamicFieldsView extends StatelessWidget {
  const DynamicFieldsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dynamic Input Fields")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<DynamicFieldsBloc, DynamicFieldsState>(
                builder: (context, state) {
                  return ListView.builder(
                    itemCount: state.fields.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Field ${index + 1}",
                                border: const OutlineInputBorder(),
                              ),
                              initialValue: state.fields[index],
                              onChanged: (value) {
                                context.read<DynamicFieldsBloc>().add(
                                  UpdateFieldValueEvent(index, value),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (state.fields.length > 1)
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                context.read<DynamicFieldsBloc>().add(
                                  RemoveFieldEvent(index),
                                );
                              },
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                context.read<DynamicFieldsBloc>().add(AddFieldEvent());
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Field"),
            ),
          ],
        ),
      ),
    );
  }
}
