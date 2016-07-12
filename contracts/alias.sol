contract Alias {
  /* The alias database */
  mapping (uint256 => bytes32) public DB;
  mapping (bytes32 => uint256) public AliasFor;

  /* The cost of registering a long alias, multiplied by the gas price */
  uint256 public LongAliasPrice;

  /* The cost of registering a short alias, multiplied by the gas price */
  uint256 public ShortAliasPrice;

  /* The last short alias assigned */
  uint256 public LastShort;

  /* The admin key, for infrastructue short aliases */
  address public Admin;

  /* The top of the range reserved for short aliases */
  uint256 public AliasMin;

  /* Alias creation event */
  event AliasCreated(uint256 indexed key, bytes32 indexed value);

  function Alias() {
    LastShort = 0x100;
    LongAliasPrice = 5000000;
    ShortAliasPrice = 100000;
    Admin = msg.sender;
    /* This is 16 bytes. If you want a long alias that is shorter than
       16 bytes, just left align it rather than right align */
    AliasMin = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
  }

  function SetAlias(uint256 k, bytes32 v)
  {
    /* Need to pay for alias creation */
    if (msg.value < LongAliasPrice*tx.gasprice) {
      throw;
    }
    /* Cannot assign in short alias range */
    if (k <= AliasMin && msg.sender != Admin) {
      throw;
    }
    /* Cannot reasign aliases */
    if (DB[k] != 0x0) {
      throw;
    }
    if (AliasFor[v] == 0x0) {
      AliasFor[v] = k;
    }
    DB[k] = v;
    AliasCreated(k, v);
  }

  function CreateShortAlias(bytes32 v)
  {
    /* Need to pay for alias creation */
    if (msg.value < ShortAliasPrice*tx.gasprice) {
      throw;
    }
    LastShort += 1;
    DB[LastShort] = v;
    if (AliasFor[v] == 0x0) {
      AliasFor[v] = LastShort;
    }
    AliasCreated(LastShort, v);
  }

}
