;; Loyalty Rewards Smart Contract
;; This contract enables the management of a loyalty reward system, where rewards are represented as non-fungible tokens (NFTs). 
;; Users can mint rewards, assign loyalty points to them, transfer ownership, burn rewards, and update their points.
;; It supports batch minting of rewards, ensuring that only the program owner can perform critical actions such as minting and burning rewards.
;; The contract maintains mappings for reward ownership, points, and burn status, along with metadata for batch processing.
;; Error handling ensures only valid actions are taken, and the contract is designed to manage both individual and batch operations efficiently.

;; Constants
(define-constant program-owner tx-sender) ;; Address of the program owner
(define-constant err-owner-only (err u200)) ;; Error for unauthorized actions by non-owners
(define-constant err-not-owner (err u201)) ;; Error for unauthorized access to resources
(define-constant err-invalid-points (err u202)) ;; Error for invalid points

;; Data Variables
(define-non-fungible-token loyalty-reward uint) ;; Loyalty reward NFT
(define-data-var last-reward-id uint u0) ;; Tracks the last assigned reward ID

;; Maps
(define-map reward-owner uint principal) ;; Maps reward IDs to their owners
(define-map reward-points uint uint) ;; Tracks loyalty points for each reward ID
(define-map burned-rewards uint bool) ;; Tracks whether a reward is burned
(define-map batch-metadata uint (string-ascii 256)) ;; Stores batch-related metadata

;; Private Helper Functions
(define-private (is-reward-owner (reward-id uint) (sender principal))
    ;; Checks if the sender is the owner of the specified reward ID
    (is-eq sender (unwrap! (map-get? reward-owner reward-id) false)))

(define-private (is-valid-points (points uint))
    ;; Validates that points are greater than or equal to 1
    (>= points u1))

(define-private (is-reward-burned (reward-id uint))
    ;; Checks if the reward has already been burned
    (default-to false (map-get? burned-rewards reward-id)))

(define-private (is-valid-reward-id (reward-id uint))
    ;; Checks if the reward ID exists
    (is-some (map-get? reward-owner reward-id)))
