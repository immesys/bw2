library bw {

  /* VerifyEd25519Packed(bytes object)
   * sig: VerifyEd25519Packed(bytes) (bool)
   * returns true if valid, false otherwise
   */
  function VerifyEd25519Packed(bytes blob) returns (bool) {}

  /* VerifyEd25519(bytes32 vk, bytes sig, bytes body)
   * sig: VerifyEd25519(bytes32,bytes,bytes) (bool)
   * returns true if valid, false otherwise
   */
  function VerifyEd25519(bytes32 vk, bytes sig, bytes body) returns (bool) {}

  /* UnpackDOT(bytes dot)
   * sig: UnpackDOT(bytes) (bool valid, uint8 numrevokers, bool ispermission,
   *												uint64 expiry, bytes32 srcvk, bytes32 dstvk, bytes32 dothash)
   */
  function UnpackDOT(bytes dot)
  returns (bool, uint8, bool, uint64, bytes32, bytes32, bytes32) {}

  /* GetDOTDelegatedRevoker(bytes32 dothash, uint8 index)
   * sig: GetDOTDelegatedRevoker(bytes32,uint8) (bytes32)
   * The DOT must have been unpacked within the calling contract
   */
  function GetDOTDelegatedRevoker(bytes32 dothash, uint8 index)
  returns (bytes32) {}

  /* UnpackEntity(bytes entity)
  /* sig: UnpackEntity(bytes) (bool valid, uint8 numrevokers, uint64 expiry, bytes32 vk)
  */
  function UnpackEntity(bytes entity)
  returns (bool valid, uint8 numrevokers, uint64 expiry, bytes32 vk) {}

  /* GetEntityDelegatedRevoker(bytes32 vk, uint8 index)
   * sig: GetEntityDelegatedRevoker(bytes32,index) (bytes32)
   * Returns a delegated revoker for an entity.
   * Entity must have been unpacked within the calling contract
   */
  function GetEntityDelegatedRevoker(bytes32 vk, uint8 index)
  returns (bytes32) {}

  /* UnpackAccessDCHain(bytes obj)
   * sig: UnpackAccessDChain(bytes) (bool valid, uint8 numdots, bytes32 chainhash)
   * obj len must be a multiple of 32
   * Also puts the dchain in scratch
   */
  function UnpackAccessDChain(bytes obj)
  returns (bool valid, uint8 numdots, bytes32 chainhash) {}

  /* GetDChainDOTHash(bytes32 chainhash, index) (bytes32 dothash)
   * sig: GetDChainDOTHash(bytes32,uint8) (bytes32 dothash)
   * chain must be in scratch
   */
  function GetDChainDOTHash(bytes32 chainhash, uint8 index)
  returns (bytes32 dothash) {}

  /* SliceByte32(bytes, offset) (bytes32)
   * sig: SliceByte32(bytes,uint32) (bytes32)
   */
  function SliceByte32(bytes blob, uint32 offset)
  returns (bytes32) {}

  /*
   * UnpackRevocation(bytes) (bool valid, bytes32 target, bytes32 vk)
   * sig: UnpackRevocation(bytes) (bool,bytes32,bytes32)
   */
  function UnpackRevocation(bytes blob)
  returns (bool valid, bytes32 target, bytes32 vk) {}

  /* ADChainGrants(bytes32 chainhash, bytes8 adps, bytes32 mvk, bytes urisuffix)
   * sig: ADChainGrants(bytes32,bytes8,bytes32,bytes) (uint16)
   * rv = 200 if chain is valid, and all dots are valid and unexpired and
   *          it grants a superset of the passed adps, mvk and suffix
   *          and all the entities are known to be unexpired
   * rv = 201 same as above, but some entities were not present in Scratch
   * else  a BWStatus code that something went wrong
   */
  function ADChainGrants(bytes32 chainhash, bytes8 adps, bytes32 mvk, bytes urisuffix)
  returns (uint16 bwstatus) {}

  /* GetDOTNumRevokableHashes(bytes32 dothash)
   * sig: GetDOTNumRevokableHashes(bytes32) (uint32)
   * Gets the total number of vulnerable hashes for the given dot
   * DOT must be in scratch
   */
  function GetDOTNumRevokableHashes(bytes32 dothash)
  returns (uint32) {}

  /* GetDOTRevokableHash(bytes32 dothash, uint32 index)
   * sig: GetDOTRevokableHash(bytes32,uint32) (bytes32)
   */
  function GetDOTRevokableHash(bytes32 dothash, uint32 index)
  returns (bytes32) {}

  /* GetDChainNumRevokableHashes(bytes32 chainhash)
   * sig: GetDChainNumRevokableHashes(bytes32) (uint32)
   */
  function GetDChainNumRevokableHashes(bytes32 chainhash)
  returns (uint32) {}

  /* GetDChainRevokableHash(bytes32 chainhash, uint32 index)
   * sig: GetDChainRevokableHash(bytes32,uint32) (bytes32)
   */
  function GetDChainRevokableHash(bytes32 chainhash, uint32 index)
  returns (bytes32) {}
}
