
contract bw {

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
   * UnpackRevocation(bytes) (bool valid, bytes32 vk, bytes32 target)
   * sig: UnpackRevocation(bytes) (bool,bytes32,bytes32)
   */
  function UnpackRevocation(bytes blob)
  returns (bool valid, bytes32 vk, bytes32 target) {}

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


contract Registry {

    modifier onlyadmin { if (msg.sender != admin) throw; _ }
    address public admin;

    enum Validity { Unknown, Valid, Expired, Revoked }

    /* Events so that light clients can follow interactions with the registry */
    event NewDOT(bytes32 indexed hash, bytes object);
    event NewEntity(bytes32 indexed vk, bytes object);
    event NewDChain(bytes32 indexed hash, bytes object);
    event NewDOTRevocation(bytes32 indexed hash, bytes object);
    event NewEntityRevocation(bytes32 indexed vk, bytes object);
    event NewRevocationBounty(bytes32 indexed key, uint newValue);

    /* The state of the registry */
    struct EntityEntry
    {
      bytes blob;
      Validity validity;
      uint expiry;
    }
    mapping (bytes32 => EntityEntry) public Entities;

    struct DOTEntry
    {
      bytes blob;
      Validity validity;
      uint expiry;
    }
    mapping (bytes32 => DOTEntry) public DOTs;
    struct DChainEntry
    {
      bytes blob;
      Validity validity;
      uint since;
    }
    mapping (bytes32 => DChainEntry) public DChains;
    mapping (bytes32 => uint) public RevocationBounties;
    /* fromVK -> []dothash */
    mapping (bytes32 => bytes32[]) public DOTFromVK;


    /* Revocation Infrastructure */
    function AddRevocationBounty(bytes32 hash)
    {
      /* This would be silly to do if there was already a revocation... */
      RevocationBounties[hash] += msg.value;
      NewRevocationBounty(hash, RevocationBounties[hash]);
    }

    /* AddDOT will add a DOT but only if it is valid, and the entities it
       refers to are also valid and in the registry. */
    function AddDOT(bytes content)
    {
      var (valid, numrevokers, ispermission, expiry, srcvk, dstvk, hash) = bw(0x28589).UnpackDOT(content);

      /* Even if DOT is invalid, we keep their money so may as well record,
         even if we are assigning to zero hash */
      RevocationBounties[hash] += msg.value;
      NewRevocationBounty(hash, RevocationBounties[hash]);

      /* Next, stop if the DOT was invalid */
      if (!valid) {
        return;
      }

      /* Check the entity expiries */
      CheckEntity(srcvk);
      CheckEntity(dstvk);

      /* Stop if the entities are not ok */
      if (Entities[srcvk].validity != Validity.Valid ||
          Entities[dstvk].validity != Validity.Valid) {
        return;
      }

      /* Stop if DOT is known */
      if (DOTs[hash].validity != Validity.Unknown) {
        return;
      }

      /* Find the min expiry for the DOT */
      uint minExpiry = expiry;
      if (minExpiry == 0 || (Entities[srcvk].expiry != 0 && Entities[srcvk].expiry < minExpiry)) {
        minExpiry = Entities[srcvk].expiry;
      }
      if (minExpiry == 0 || (Entities[dstvk].expiry != 0 && Entities[dstvk].expiry < minExpiry)) {
        minExpiry = Entities[dstvk].expiry;
      }

      /* Put it in */
      if (minExpiry == 0 || minExpiry > block.timestamp) {
        DOTs[hash].blob = content;
        DOTs[hash].expiry = minExpiry;
        DOTFromVK[srcvk].push(hash);
        DOTs[hash].validity = Validity.Valid;
        NewDOT(hash, content);
      }
    }

    function AddEntity(bytes content)
    {
      var (valid, numrevokers, expiry, vk) = bw(0x28589).UnpackEntity(content);

      /* Even if Entity is invalid, we keep their money so may as well record,
         even if we are assigning to zero hash */
      RevocationBounties[vk] += msg.value;
      NewRevocationBounty(vk, RevocationBounties[vk]);

      /* Next, stop if the Entity was invalid */
      if (!valid) {
        return;
      }

      /* Stop if the Entity is known */
      if (Entities[vk].validity != Validity.Unknown) {
        return;
      }

      /* Put it in */
      if (expiry == 0 || expiry > block.timestamp) {
        Entities[vk].blob = content;
        Entities[vk].validity = Validity.Valid;
        Entities[vk].expiry = expiry;
        NewEntity(vk, content);
      }
    }

    /* This will update the entity state to expired if it has expired */
    function CheckEntity(bytes32 vk) {
      if (Entities[vk].validity != Validity.Valid) {
        return;
      }
      if (Entities[vk].expiry != 0 && Entities[vk].expiry < block.timestamp) {
        Entities[vk].validity = Validity.Expired;
      }
    }

    /* This will update the dot state to expired if it has expired */
    /* We don't do revocation because it's pretty expensive and
       there is ample motivation for it to happen elsewhere */
    function CheckDOT(bytes32 hash) {
      if (DOTs[hash].validity != Validity.Valid) {
        return;
      }
      if (DOTs[hash].expiry != 0 && DOTs[hash].expiry < block.timestamp) {
        DOTs[hash].validity = Validity.Expired;
      }
    }


    function AddChain(bytes content)
    {
      var (valid, numdots, chainhash) = bw(0x28589).UnpackAccessDChain(content);

      /* Even if chain is invalid, we keep their money so may as well record,
         even if we are assigning to zero hash */
      RevocationBounties[chainhash] += msg.value;
      NewRevocationBounty(chainhash, RevocationBounties[chainhash]);

      /* Stop if invalid */
      if (!valid) {
        return;
      }

      /* Stop if the chain is known */
      if (DChains[chainhash].validity != Validity.Unknown) {
        return;
      }

      /* Now we assemble the chain into scratch */
      for (uint8 dotidx = 0; dotidx < numdots; dotidx++) {
        bytes32 dothash = bw(0x28589).GetDChainDOTHash(chainhash, dotidx);
        CheckDOT(dothash);
        if (DOTs[dothash].validity != Validity.Valid) {
          return;
        }
        var (_1,_2,_3,_4,srcvk,dstvk,_5) = bw(0x28589).UnpackDOT(DOTs[dothash].blob);
        CheckEntity(srcvk);
        CheckEntity(dstvk);
        if (Entities[srcvk].validity != Validity.Valid ||
            Entities[dstvk].validity != Validity.Valid) {
          return;
        }
        bw(0x28589).UnpackEntity(Entities[srcvk].blob);
        bw(0x28589).UnpackEntity(Entities[dstvk].blob);
      }

      /* Now validate the full chain */
      uint16 rv = bw(0x28589).ADChainGrants(chainhash, 0x0, 0x0, "");

      /* And put it in */
      if (rv == 200) {
        DChains[chainhash].blob = content;
        DChains[chainhash].validity = Validity.Valid;
        NewDChain(chainhash, content);
      }
    }

    function RevokeEntity(bytes32 target, bytes content)
    {
      /* this will be a nop if it's not an entity */
      CheckEntity(target);
      if (Entities[target].validity != Validity.Valid) {
        return;
      }
      var (_1, numrevokers, _2, _3) = bw(0x28589).UnpackEntity(Entities[target].blob);
      var (validsig, rtarget, rvk) = bw(0x28589).UnpackRevocation(content);
      if (!validsig || rtarget != target) {
        return;
      }
      bool validrevoker = (rvk == rtarget);
      if (!validrevoker) {
        for (; numrevokers > 0; numrevokers--) {
          bytes32 allowed_rvk = bw(0x28589).GetEntityDelegatedRevoker(rtarget, numrevokers-1);
          if (allowed_rvk == rvk) {
            validrevoker = true;
          }
        }
      }
      if (!validrevoker) {
        return;
      }
      Entities[target].validity = Validity.Revoked;
      NewEntityRevocation(target, content);
      if (RevocationBounties[target] != 0 && msg.sender.send(RevocationBounties[target])) {
        RevocationBounties[target] = 0;
      }
      return;
    }
    function RevokeDOT(bytes32 target, bytes content)
    {
      CheckDOT(target);
      if (DOTs[target].validity != Validity.Valid) {
        return;
      }
      bool  validsig;
      uint8  numrevokers;
      bool _bool;
      uint64  _u64;
      bytes32 srcvk;
      bytes32 dstvk;
      bytes32 rtarget;
      (validsig,numrevokers,_bool,_u64,srcvk,dstvk,rtarget) = bw(0x28589).UnpackDOT(DOTs[target].blob);
      CheckEntity(srcvk);
      bw(0x28589).UnpackEntity(Entities[srcvk].blob);
      CheckEntity(dstvk);
      bw(0x28589).UnpackEntity(Entities[dstvk].blob);
      /* dstvk now means the vk that signed the revocation */
      (validsig, rtarget, dstvk) = bw(0x28589).UnpackRevocation(content);
      if (!validsig || rtarget != target) {
        return;
      }
      bool validrevoker = (srcvk == dstvk);
      /* rtarget now means a VK allowed to revoke */
      if (!validrevoker) {
        for (;numrevokers>0; numrevokers--) {
          rtarget = bw(0x28589).GetDOTDelegatedRevoker(target, numrevokers-1);
          if (rtarget == dstvk) {
            validrevoker = true;
          }
        }
      }
      if (!validrevoker) {
        return;
      }
      DOTs[target].validity = Validity.Revoked;
      NewDOTRevocation(target, content);
      if (RevocationBounties[target] != 0 && msg.sender.send(RevocationBounties[target])) {
        RevocationBounties[target] = 0;
      }
    }


    function Registry() {
      PatentPrice = 10 ether;
      PatentDuration = 100;
      admin = msg.sender;
    }


    /* Patent infrastructure */
    uint public PatentPrice;
    uint public PatentDuration;
    event Patent(bytes32 indexed hash);
    mapping (bytes32 => address) public Patents;
    mapping (bytes32 => uint) public PatentExpiry;

    /* Be careful to give the contract extra money if there are
       outstanding patents */
    function SetPatentProperties(uint price, uint duration)
      onlyadmin
    {
      PatentPrice = price;
      PatentDuration = duration;
    }

    /* These are the Registry functions */
    function NewPatent(bytes32 hash)
    {
      /* Pay up */
      if (msg.value < PatentPrice) throw;
      /* Still a valid patent there bud */
      if (PatentExpiry[hash] != 0x0 && block.number < PatentExpiry[hash]) throw;
      Patents[hash] = msg.sender;
      PatentExpiry[hash] = block.number + PatentDuration;
      Patent(hash);
    }
    function WhoHoldsPatentFor(bytes32 hash) returns (address)
    {
      if (Patents[hash] == 0) return 0;
      if (block.number >= PatentExpiry[hash]) {
        Patents[hash] = 0;
        PatentExpiry[hash] = 0;
        return 0;
      }
      return Patents[hash];
    }
    function ClosePatent(bytes32 hash)
    {
      /* Can only claim your own patent */
      if (Patents[hash] != msg.sender) throw;
      /* Can only claim unexpired patents */
      if (block.number >= PatentExpiry[hash]) {
        Patents[hash] = 0;
        PatentExpiry[hash] = 0;
        return;
      }
      /* Can only claim a patent refund if you put your
         stuff in public domain */
      if (DOTs[hash].validity == Validity.Unknown &&
          Entities[hash].validity == Validity.Unknown &&
          DChains[hash].validity == Validity.Unknown)
      {
        /* Not in public domain */
        return;
      }
      Patents[hash] = 0x0;
      PatentExpiry[hash] = 0x0;
      /* What a good guy! You shared your stuff! Get some money */
      if (!msg.sender.send(PatentPrice))
        throw;

      /* Note that patents do not cover revocations because
         you can use a bounty for that */
    }
    /*
      The reason we have this, is that the registry contract will
      likely have a lot of storage attached to it. And a selfdestruct
      will allow not keeping that on the chain forever.
     */
    function Retire() onlyadmin
    {
      selfdestruct(msg.sender);
    }
}
