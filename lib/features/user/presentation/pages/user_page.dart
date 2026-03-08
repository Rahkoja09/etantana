import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_tantana/features/user/presentation/controller/user_controller.dart';

class UserPage extends ConsumerStatefulWidget {
  const UserPage({super.key});

  @override
  ConsumerState<UserPage> createState() => _UserPageState();
}

class _UserPageState extends ConsumerState<UserPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Chargement initial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userControllerProvider.notifier).searchUser(null);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(userControllerProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("User"),
      ),
      body: state.isLoading && (state.users?.isEmpty ?? true)
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: (state.users?.length ?? 0) + (state.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < (state.users?.length ?? 0)) {
                  final item = state.users![index];
                  return ListTile(
                    title: Text(item.id ?? "No ID"),
                    subtitle: Text(item.createdAt?.toString() ?? ""),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
    );
  }
}