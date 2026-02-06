// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CropBatch
 * @author Agri-Chain
 * @notice Immutable ledger of crop batch lifecycle events
 * @dev This contract is intentionally minimal and boring
 */
contract CropBatch {
    // -------------------------
    // ENUMS
    // -------------------------

    enum State {
        Harvested,
        Stored,
        Transported,
        ArrivedAtMarket,
        Sold
    }

    // -------------------------
    // STRUCTS
    // -------------------------

    struct Batch {
        address farmer;
        string cropType;
        string location;
        State state;
        uint256 createdAt;
    }

    // -------------------------
    // STORAGE
    // -------------------------

    uint256 public nextBatchId;
    mapping(uint256 => Batch) public batches;

    // -------------------------
    // EVENTS (SOURCE OF TRUTH)
    // -------------------------

    event BatchCreated(
        uint256 indexed batchId,
        address indexed farmer,
        string cropType,
        string location,
        uint256 timestamp
    );

    event StateUpdated(
        uint256 indexed batchId,
        State newState,
        uint256 timestamp
    );

    // -------------------------
    // FUNCTIONS
    // -------------------------

    /**
     * @notice Create a new crop batch
     */
    function createBatch(
        string calldata cropType,
        string calldata location
    ) external returns (uint256 batchId) {
        batchId = nextBatchId;

        batches[batchId] = Batch({
            farmer: msg.sender,
            cropType: cropType,
            location: location,
            state: State.Harvested,
            createdAt: block.timestamp
        });

        emit BatchCreated(
            batchId,
            msg.sender,
            cropType,
            location,
            block.timestamp
        );

        nextBatchId++;
    }

    /**
     * @notice Update lifecycle state of a batch
     */
    function updateState(
        uint256 batchId,
        State newState
    ) external {
        require(batchId < nextBatchId, "Invalid batch ID");

        batches[batchId].state = newState;

        emit StateUpdated(
            batchId,
            newState,
            block.timestamp
        );
    }

    /**
     * @notice Get current state of a batch
     */
    function getCurrentState(uint256 batchId)
        external
        view
        returns (State)
    {
        require(batchId < nextBatchId, "Invalid batch ID");
        return batches[batchId].state;
    }
}
