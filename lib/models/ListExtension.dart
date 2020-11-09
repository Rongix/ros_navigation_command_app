extension ListExtension<T> on List<T> {
  List insertEveryNth(T item, {int insertOffset = 2}) {
    assert(insertOffset > 1);

    var listLength = length + (length / (insertOffset - 1)).floor();
    var returnList = List<T>(listLength);
    var listIterator = iterator;

    for (var i = 0; i < listLength; ++i) {
      if (i % insertOffset != insertOffset - 1 && listIterator.moveNext()) {
        returnList[i] = listIterator.current;
      } else {
        returnList[i] = item;
      }
    }

    return returnList;
  }
}
