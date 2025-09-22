import 'package:flutter/material.dart';
import 'dart:async';
import '../models/shoe_model.dart';
import '../services/shoe_service.dart';
import 'shoe_details_screen.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final ShoeService _shoeService = ShoeService();
  final TextEditingController _searchController = TextEditingController();
  List<ShoeModel> _shoes = [];
  bool _isLoading = false;
  String? _error;
  bool _hasMoreData = true;
  final ScrollController _scrollController = ScrollController();

  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _loadShoes();
    _scrollController.addListener(_onScroll);
    _shoeService.startListening();
    _subscription = _shoeService.updates.listen((updatedShoes) {
      setState(() {
        _shoes = updatedShoes;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _subscription?.cancel();
    _shoeService.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!_isLoading && _hasMoreData) {
        _loadMoreShoes();
      }
    }
  }

  Future<void> _loadShoes({String? search}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final shoes = await _shoeService.getShoes(
        keyword: search,
      );
      setState(() {
        _shoes = shoes;
        _hasMoreData = shoes.length >= 20;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load shoes: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreShoes() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final moreShoes = await _shoeService.getShoes(
        keyword: _searchController.text.isEmpty ? null : _searchController.text,
      );

      setState(() {
        _shoes.addAll(moreShoes);
        _hasMoreData = moreShoes.length >= 20;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load more shoes: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search shoes...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white),
                          onPressed: () {
                            _searchController.clear();
                            _loadShoes();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (value) => _loadShoes(search: value),
              ),
            ),
            Expanded(
              child: _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _loadShoes(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _shoes.length + (_hasMoreData ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _shoes.length) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final shoe = _shoes[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShoeDetailsPage(
                                  shoeId: shoe.id,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: shoe.images.isNotEmpty
                                        ? Container(
                                            height: 180,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(12),
                                              ),
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                                shoe.images.first,
                                                fit: BoxFit.contain,
                                                height: 160,
                                              ),
                                            ),
                                          )
                                        : const Center(
                                            child: Icon(
                                              Icons.image_not_supported,
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                          ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        shoe.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        shoe.brand,
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${shoe.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}